// vim: tabstop=4:softtabstop=4:shiftwidth=4:noexpandtab
`ifndef _BIO_H_
`define _BIO_H_ 1

`define      Bsize       100*8192
`define      Bungetsize  4       /* space for ungetc */
`define      Bmagic     'h314159
`define      Beof        -1
`define      Bbad        -2

`define      Binactive   0       /* states */
`define      Bractive    1
`define      Bwactive    2
`define      Bracteof    3

`define      Bend        4

`define      MAXBUFS     20

`define      OREAD       0       /* open for read */
`define      OWRITE      1       /* write */
`define      ORDWR       2       /* read and write */
`define      OEXEC       3       /* execute, == read but check execute permission */
`define      OTRUNC      16      /* or'ed in (except for exec), truncate file first */
`define      OCEXEC      32      /* or'ed in, close on exec */
`define      ORCLOSE     64      /* or'ed in, remove on close */
`define      ODIRECT     128     /* or'ed in, direct access */
`define      ONONBLOCK   256     /* or'ed in, non-blocking call */
`define      OEXCL      'h1000   /* or'ed in, exclusive use (create only) */
`define      OLOCK      'h2000   /* or'ed in, lock after opening */
`define      OAPPEND    'h4000   /* or'ed in, append only */

`define      AEXIST      0       /* accessible: exists */
`define      AEXEC       1       /* execute access */
`define      AWRITE      2       /* write access */
`define      AREAD       4       /* read access */

typedef class Biobuf;

static   Biobuf wbufs[`MAXBUFS];
static   int    atexitflag;

typedef enum {_file, _process} Type;

class Biobuf;
  int              icount = 0;      /* neg num of bytes at eob */
  int              ocount;          /* num of bytes at bob */
  int              rdline = 0;      /* num of bytes after rdline */
  int              state;           /* r/w/inactive */
  int  unsigned    fid;             /* open file */
  int              flag = 0;        /* magic if malloc'ed */
  longint unsigned offset = 0;      /* offset of buffer in file */
  int              bsize;           /* size of buffer */
  int              bbuf;            /* pointer to beginning of buffer */
  int              ebuf;            /* pointer to end of buffer */
  int              gbuf;            /* pointer to good data in buf */
  byte unsigned    b[`Bungetsize+`Bsize];
  Type             ty = _file;

  function new(int unsigned f = 0, int mode = `OREAD, Type ty = _file);
    void'(Binits(f, mode, `Bungetsize +`Bsize));
    flag = `Bmagic;
    this.ty = ty;
  endfunction

  function int Binits(int unsigned f, int mode, int size);
    int p = 0;
    p += `Bungetsize;   /* make room for Bungets */
    size -= `Bungetsize;

    case(mode & ~(`OCEXEC|`ORCLOSE|`OTRUNC))
      `OREAD: begin
        state = `Bractive;
        ocount = 0;
      end
      `OWRITE: begin
        install(this);
        state = `Bwactive;
        ocount = -size;
      end
      default: begin
        $write("Bopen: unknown mode %0d\n", mode);
        return `Beof;
      end
    endcase

    bbuf = p;
    ebuf = p + size;
    bsize = size;
    gbuf = ebuf;
    fid = f;
    return 0;
  endfunction

  function int Binit(int unsigned f, int mode);
    return Binits(f, mode, `Bungetsize +`Bsize);
  endfunction

  task close();
    case(ty)
      _file:      $fclose(fid);
      _process:   $error("not supported");
    endcase
  endtask

  function int read(int bbuf_, int bsize_);
    case(ty)
      _file:      read = $fread(b, fid, bbuf_, bsize_);
      _process:   $error("not supported");
    endcase
  endfunction

  task write(byte unsigned s[], int unsigned start, int unsigned count);
    case(ty)
      _file:      for (int i = start; i < start + count; i++) $fwrite(fid, "%c", s[i]);
      _process:   $error("not supported");
    endcase
  endtask

  task flush();
    case(ty)
      _file:      $fflush(fid);
      _process:   $error("not supported");
    endcase
  endtask

  function int seek(int offset_, int op_);
    case(ty)
      _file:      seek = $fseek(fid, offset_, op_);
      _process:   $error("not supported");
    endcase
  endfunction

  task Bterm();
    deinstall(this);
    void'(Bflush());
    if(flag == `Bmagic) begin
      flag = 0;
      close();
    end
  endtask

  function int Bgetc();
    int i;

    while(1) begin
      i = icount;
      if(i != 0) begin
        icount = i + 1;
        return b[i + ebuf];
      end
      if(state != `Bractive) begin
        if(state == `Bracteof)
          state = `Bractive;
        return `Beof;
      end
      /*
      * get next buffer, try to keep Bungetsize
      * characters pre-catenated from the previous
      * buffer to allow that many ungets.
      */
      for (int j = 0 ; j < `Bungetsize; j++)
        b[bbuf - `Bungetsize + j] = b[ebuf - `Bungetsize + j];

      i = read(bbuf, bsize);

      gbuf = bbuf;
      if(i <= 0) begin
        state = `Bracteof;
        if(i < 0)
          state = `Binactive;
        return `Beof;
      end
      if(i < bsize) begin
        for (int j = i + `Bungetsize - 1; j >= 0 ; j--)
          b[ebuf - i - `Bungetsize + j] = b[bbuf - `Bungetsize + j];
        gbuf = ebuf - i;
      end
      icount = -i;
      offset += i;
    end
  endfunction

  function int Bungetc();
    if(state == `Bracteof)
      state = `Bractive;
    if(state != `Bractive)
      return `Beof;
    icount--;
      return 1;
  endfunction

  function int Bflush();
    case (state)
      `Bwactive: begin
        int n = bsize + ocount;
        if(n == 0)
          return 0;
        write(b, bbuf, n);
        flush();

        offset += n;
        ocount = - bsize;
        return 0;
      end
      `Bracteof: state = `Bractive;
      `Bractive: begin
        icount = 0;
        gbuf = ebuf;
        return 0;
      end
    endcase
    return `Beof;
  endfunction

  function int Bputc(byte c);
    int i;

    while(1) begin
      i = ocount;
      if(i) begin
        b[ebuf + i] = c;
        ocount = ++i;
        return 0;
      end
      if(Bflush() == `Beof)
        break;
    end
    return `Beof;
  endfunction

  function string Brdline(byte delim = 10);
    string res;
    int ip = 0, ep = 0;
    int i, j, k;

    i = -icount;
    if(i == 0) begin
      /*
       * eof or other error
       */
      if(state != `Bractive) begin
        if(state == `Bracteof)
          state = `Bractive;
        rdline = 0;
        gbuf = ebuf;
        return "";
      end
    end

    /*
     * first try in remainder of buffer (gbuf doesn't change)
     */
    ip = ebuf - i;
    for (k = 0; k < i; k++)
      if(b[k + ip] == delim) begin ep = k + ip; break; end
      if(ep) begin
        j = (ep - ip) + 1;
        rdline = j;
        icount += j;
        for (k = ip; k < ep; k++) res = {res, string'(b[k])};
        return res;
      end

    /*
     * copy data to beginning of buffer
     */
    if(i < bsize)
      for (k = i - 1; k >= 0; k--)
        b[bbuf + k] = b[ip + k];
    gbuf = bbuf;

    /*
     * append to buffer looking for the delim
     */
    ip = bbuf + i;
    while(i < bsize) begin
      j = read(ip, bsize-i);
      if(j <= 0) begin
        /*
         * end of file with no delim
         */
        for (k = i - 1; k >= 0; k--)
          b[ebuf - i + k] = b[bbuf + k];
        rdline = i;
        icount = -i;
        gbuf = ebuf - i;
        return "";
      end
      offset += j;
      i += j;
      for (k = 0; k < j; k++)
        if(b[ip + k] == delim) begin ep = ip + k; break; end
        if(ep) begin
          /*
           * found in new piece
           * copy back up and reset everything
           */
          ip = ebuf - i;
          if(i < bsize) begin
            for (k = i - 1; k >= 0; k--)
              b[ip + k] = b[bbuf + k];
            gbuf = ip;
          end
          j = (ep - bbuf) + 1;
          rdline = j;
          icount = j - i;
          for (k = ip; k < ep; k++) res = {res, string'(b[k])};
          return res;
        end
      ip += j;
    end

    /*
     * full buffer without finding
     */
     rdline = bsize;
    icount = -bsize;
    gbuf = bbuf;
    return "";
  endfunction

  function int Blinelen();
    return rdline;
  endfunction

  function longint Boffset();
    longint n;

    case(state)
      `Bracteof, `Bractive: n = offset + icount;
      `Bwactive: n = offset + (bsize + ocount);
      default: begin
        $write("Boffset: unknown state %d\n", state);
        n = `Beof;
      end
    endcase
    return n;
  endfunction

  function longint Bseek(longint offset, int base);
    longint n, d;
    int bufsz;

    case(state)
      `Bracteof: begin
        state = `Bractive;
        icount = 0;
        gbuf = ebuf;
      end
      `Bractive: begin
        n = offset;
        if(base == 1) begin
          n += Boffset();
          base = 0;
        end

        /*
         * try to seek within buffer
         */
        if(base == 0) begin
          d = n - Boffset();
          bufsz = ebuf - gbuf;
          if(-bufsz <= d && d <= bufsz) begin
            icount += d;
            if(d >= 0) begin
              if(icount <= 0)
                return n;
            end else begin
              if(ebuf - gbuf >= -icount)
                return n;
            end
          end
        end

        /*
         * reset the buffer
         */
        n = seek(n, base);
        icount = 0;
        gbuf = ebuf;
      end
      `Bwactive: begin
        void'(Bflush());
        n = seek(offset, base);
      end
      default: begin
        $write("Bseek: unknown state %0d\n", state);
        return `Beof;
      end
    endcase
    offset = n;
    return n;
  endfunction

  function longint Bread(longint unsigned count, ref byte unsigned ap[]);
    longint unsigned c = count, i = 0;
    int n, ic = icount, k = 0;

    while(c > 0) begin
      n = -ic;
      if(n > c)
        n = c;
      if(n == 0) begin
        if(state != `Bractive)
          break;
        i = read(bbuf, count);
        if(i <= 0) begin
          state = `Bracteof;
          if(i < 0)
            state = `Binactive;
          break;
        end
        gbuf = bbuf;
        offset += i;
        if(i < bsize) begin
          for (int j = i - 1 ; j >= 0; j--)
            b[ebuf - i + j] = b[bbuf + j];
          gbuf = ebuf - i;
        end
        ic = -i;
        continue;
      end
      for (int j = 0 ; j < n; j++)
        ap[k++] = b[ebuf + ic + j];
      c -= n;
      ic += n;
    end
    icount = ic;
    return count - c;
  endfunction

  function longint Bwrite(longint unsigned count, input byte unsigned ap[]);
    longint unsigned c = count;
    int ap_idx = 0;
    int i, n = 0, oc = ocount;

    while(c > 0) begin
      n = -oc;
      if(n > c)
        n = c;
      if(n == 0) begin
        if(state != `Bwactive)
          return `Beof;

        write(b, bbuf, bbuf + bsize);
        flush();

        offset += i;
        oc = -bsize;
        continue;
      end
      for (int j = 0 ; j < n; j++)
        b[ebuf + oc +  j] = ap[ap_idx + j];
      oc += n;
      c -= n;
      ap_idx += n;
    end
    ocount = oc;
    return count - c;
  endfunction

  function string Brdstr(int delim = 10, int nulldelim = 0);
    string p, q;
    int n, linelen, i;
    byte unsigned nq[];

    n = 0;
    while(1) begin
      p = Brdline(delim);
      linelen = Blinelen();
      if(n == 0 && linelen == 0)
        return "";
      if(p != "") begin
        for (i = 0; i < linelen; i++)
          q = {q, p[i]};
        n += linelen;
        if(nulldelim)
          q[n-1] = "\0";
        break;
      end
      if(linelen == 0)
        break;
      nq = new[linelen];
      void'(Bread(linelen, nq));
      for (i = 0; i < linelen; i++)
        q = {q, nq[i]};
      n += linelen;
    end
    q[n] = "\0";
    return q;
  endfunction
endclass

task bcat(Biobuf bin, Biobuf bout, string name);
  int unsigned n;
  byte unsigned buf_[];

  buf_ = new[256];

  while((n = bin.Bread(256, buf_)) > 0) begin
    if(bout.Bwrite(n, buf_) < 0)
      $write("bcat: writing during %s:\n", name);
    void'(bout.Bflush());
  end
  if(n < 0)
    $write("bcat: reading %s: \n", name);
endtask

function void batexit();
  Biobuf bp;
  int i;

  for(i=0; i<`MAXBUFS; i++) begin
    bp = wbufs[i];
    if(bp != null) begin
      wbufs[i] = null;
      void'(bp.Bflush());
    end
  end
endfunction

function void deinstall(Biobuf bp);
  int i;

  for(i=0; i<`MAXBUFS; i++)
    if(wbufs[i] == bp)
      wbufs[i] = null;
endfunction

function void install(Biobuf bp);
  int i;

  deinstall(bp);
  for(i=0; i<`MAXBUFS; i++)
    if(wbufs[i] == null) begin
      wbufs[i] = bp;
      break;
    end
  if(atexitflag == 0) begin
    atexitflag = 1;
  end
endfunction

function Biobuf Bopen(string name, int mode);
  int unsigned f;

  case(mode &~ (`OCEXEC|`ORCLOSE|`OTRUNC))
    `OREAD: begin
      f = $fopen(name, "r");
      if(f < 0)
        return null;
    end
    `OWRITE: begin
      f = $fopen(name, "wb");
      if(f < 0)
        return null;
    end
    default: begin
      $write("Bopen: unknown mode %0d\n", mode);
      return null;
    end
  endcase
  Bopen = new(f, mode);
  if(Bopen == null)
    $fclose(f);
endfunction

`endif

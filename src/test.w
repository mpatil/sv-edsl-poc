var a = 1 * 2 + 1 / 3 - 1 * 4;

procedure charsign_0 () {
  var msi_intr = 0;
  var msix_intr = 0;
  var errored = 0;

  var msi_dw0 = 0;
  var msix_dw0 = 0;

  if (msi_dw0[16] == 1)
    msi_intr = 1;

  if (msix_dw0[31] == 1)
    msix_intr = 1;

  regwr (0x487008, 1);

  print ("Configuring Vaults...\n");

  regwr (0x600000c, 0x00000fee);
  regwr (0x6000010, 0xd0000000);

  for (i = 0; i < 5; i++) {
    print ("Waiting for interrupt...\n");
    if (msi_intr == 1)
      errored = 0;
    if (msix_intr == 1)
      errored = 1;
    if (errored) fatal(101);

    hi = regrd (0x487004);
    lo = regrd (0x487000);

    if (lo[0] == 0) {
      print ("checking batch done status of vault 0\n");
      b_0 = regrd (0x6008000);
      if (b_0[0] == 1) fatal(10);
      regwr (0x6007ffc, 1);
    }

    regwr(0x487004, hi);
    regwr(0x487000, lo);
  }

  print (".. done!!\n");
}

charsign_0 ();


print ("charsign_0 Done!\n");

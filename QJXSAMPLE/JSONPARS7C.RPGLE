      * ------------------------------------------------------------- *
      * Json - XML and more.
      *
      * Join an array and return is as string
      *
      * ------------------------------------------------------------- *
     H BndDir('XMLPARSER') dftactgrp(*NO) ACTGRP('QILE' )
      /include jsonParser
     D pJson           s               *
     D msg             s             50    varying

      /free
        *inlr = *on;

        pJson = json_ParseString ('                                -
          {                                                        -
             arr1: [                                               -
                "The ",                                            -
                "little ",                                         -
                "brown fox"                                        -
             ]                                                     -
          }                                                        -
        ');

        // Glue all array elements together as one string
        msg = json_getStrJoin(pJson : 'arr1' );
        dsply msg;

        json_close(pJson);

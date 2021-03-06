      * ------------------------------------------------------------- *
      * This sample shows the use of the buildin JSONparser in
      * IceBreak
      *
      * Using SQL cursors
      *
      * ------------------------------------------------------------- *
     H BndDir('JSONPARSER') dftactgrp(*NO) ACTGRP('QILE' )
     D manuRow         s               *
     D prodArray       s               *
     D resultArray     s               *
     D resultObj       s               *
     D manuHnd         s               *
     D prodHnd         s               *
     D sql             s            512    varying

      /include jsonParser
      /free

        // The destination object for our SQL result row
        // and the array to contain the rows
        resultArray  = json_newArray ();

        // Open our SQL cursor. Use a simple select
        sql = 'Select * from manufact';
        manuHnd  = json_sqlOpen(sql);

        // Now iterate on each row in the resultset
        manuRow = json_sqlFetchNext(manuHnd);
        dow (manuRow <> *NULL);
           // Note: the SQL can be a template, we fill with values from a json row
           sql = 'Select * from product where manuid = $manuid' ;
           prodArray  = json_sqlResultSet(sql: 1 : 9999 : 0 : manuRow);
           // Append the row to the end of the result array.
           json_MoveObjectInto (manuRow   : 'products' : prodArray );
           json_ArrayPush (resultArray : manuRow );
           manuRow = json_sqlFetchNext(manuHnd) ;
        enddo;

        // Produce a JSON stream file in the root of the IFS
        json_writeJsonStmf(resultArray  :
           '/jsonxml/json/demo-nested.json' : 1208 : *ON
        );
        json_NodeRename( resultArray : 'ROWS');
        // Give the root a name for XML
        json_writeXmlStmf(resultArray  :
           '/jsonxml/xml/demo-nested.xml' : 1208 : *ON
        );

        // Cleanup: Close the SQL cursor, dispose the row and the array
        json_close(resultArray);
        json_sqlClose(manuHnd);
        json_sqlDisconnect();

        // If needed you can detect leaks here:
        if Json_MemLeak();
           Json_MemStat();
        endif;

        // That's it..
        *inlr = *on;

*&---------------------------------------------------------------------*
*& Report Z_RFC_COPY_TABLE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_rfc_copy_table.

PARAMETERS: tabname LIKE x030l-tabname,
            rfcdest TYPE string,
            copy    TYPE xfeld.

DATA itab TYPE STANDARD TABLE OF tabname.

CALL FUNCTION 'RFC_GET_TABLE_ENTRIES' DESTINATION rfcdest
  EXPORTING
*   BYPASS_BUFFER   = ' '
*   FROM_KEY        = ' '
*   GEN_KEY         = ' '
*   MAX_ENTRIES     = 0
    table_name      = tabname
*   TO_KEY          = ' '
* IMPORTING
*   NUMBER_OF_ENTRIES       =
  TABLES
    entries         = itab
  EXCEPTIONS
    internal_error  = 1
    table_empty     = 2
    table_not_found = 3
    OTHERS          = 4.
IF sy-subrc <> 0.
  MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
ENDIF.

IF copy = abap_true.

  DELETE FROM (tabname).

  WRITE 'Lines deleted:' && ` ` && sy-dbcnt.

  INSERT (tabname) FROM TABLE itab.

  COMMIT WORK AND WAIT.

  SKIP.

  WRITE 'Lines inserted:' && ` ` && sy-dbcnt.

ENDIF.

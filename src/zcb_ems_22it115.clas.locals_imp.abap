CLASS lsc_ZCI_EMH_22IT115 DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.
    METHODS finalize          REDEFINITION.
    METHODS check_before_save REDEFINITION.
    METHODS save              REDEFINITION.
    METHODS cleanup           REDEFINITION.
    METHODS cleanup_finalize  REDEFINITION.
ENDCLASS.

CLASS lsc_ZCI_EMH_22IT115 IMPLEMENTATION.
  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
    DATA(lo_util) = zcl_emu_22it115=>get_instance( ).

    lo_util->get_hdr_value( IMPORTING ex_meter_hdr = DATA(ls_meter_hdr) ).
    lo_util->get_itm_value( IMPORTING ex_meter_itm = DATA(ls_meter_itm) ).
    lo_util->get_hdr_t_deletion( IMPORTING ex_meter_docs = DATA(lt_hdr_del) ).
    lo_util->get_itm_t_deletion( IMPORTING ex_meter_info = DATA(lt_itm_del) ).
    lo_util->get_deletion_flags( IMPORTING ex_hdr_del = DATA(lv_hdr_del) ).

    " 1. Save / Update Header
    IF ls_meter_hdr IS NOT INITIAL.
      MODIFY zem_hdr_22it115 FROM @ls_meter_hdr.
    ENDIF.

    " 2. Save / Update Reading
    IF ls_meter_itm IS NOT INITIAL.
      MODIFY zem_itm_22it115 FROM @ls_meter_itm.
    ENDIF.

    " 3. Handle Deletions
    IF lv_hdr_del = abap_true.
      LOOP AT lt_hdr_del INTO DATA(ls_del_hdr).
        DELETE FROM zem_hdr_22it115 WHERE meterid = @ls_del_hdr-meterid.
        DELETE FROM zem_itm_22it115 WHERE meterid = @ls_del_hdr-meterid.
      ENDLOOP.
    ELSE.
      LOOP AT lt_hdr_del INTO ls_del_hdr.
        DELETE FROM zem_hdr_22it115 WHERE meterid = @ls_del_hdr-meterid.
      ENDLOOP.
      LOOP AT lt_itm_del INTO DATA(ls_del_itm).
        DELETE FROM zem_itm_22it115
          WHERE meterid   = @ls_del_itm-meterid
            AND readingno = @ls_del_itm-readingno.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

  METHOD cleanup.
    zcl_emu_22it115=>get_instance( )->cleanup_buffer( ).
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.
ENDCLASS.

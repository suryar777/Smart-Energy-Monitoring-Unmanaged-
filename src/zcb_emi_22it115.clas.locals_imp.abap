CLASS lhc_EnergyMeterItm DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE EnergyMeterItm.
    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE EnergyMeterItm.
    METHODS read FOR READ
      IMPORTING keys FOR READ EnergyMeterItm RESULT result.
    METHODS rba_EnergyHeader FOR READ
      IMPORTING keys_rba FOR READ EnergyMeterItm\_EnergyHeader
      FULL result_requested RESULT result LINK association_links.
ENDCLASS.

CLASS lhc_EnergyMeterItm IMPLEMENTATION.
  METHOD update.
    DATA ls_meter_itm TYPE zem_itm_22it115.
    LOOP AT entities INTO DATA(ls_entities).
      ls_meter_itm = CORRESPONDING #( ls_entities MAPPING FROM ENTITY ).
      IF ls_meter_itm-meterid IS NOT INITIAL.
        SELECT FROM zem_itm_22it115 FIELDS *
          WHERE meterid   = @ls_meter_itm-meterid
            AND readingno = @ls_meter_itm-readingno
          INTO TABLE @DATA(lt_itm).
        IF sy-subrc EQ 0.
          DATA(lo_util) = zcl_emu_22it115=>get_instance( ).
          lo_util->set_itm_value(
            EXPORTING im_meter_itm = ls_meter_itm
            IMPORTING ex_created   = DATA(lv_created) ).
          IF lv_created EQ abap_true.
            APPEND VALUE #( meterid   = ls_meter_itm-meterid
                            readingno = ls_meter_itm-readingno )
              TO mapped-energymeteritm.
            APPEND VALUE #( %key = ls_entities-%key
              %msg = new_message( id       = 'ZEM_MSG_22IT115'
                                  number   = 001
                                  v1       = 'Reading Updated Successfully'
                                  severity = if_abap_behv_message=>severity-success ) )
              TO reported-energymeteritm.
          ENDIF.
        ELSE.
          APPEND VALUE #( %cid      = ls_entities-%cid_ref
                          meterid   = ls_meter_itm-meterid
                          readingno = ls_meter_itm-readingno )
            TO failed-energymeteritm.
          APPEND VALUE #( %cid    = ls_entities-%cid_ref
                          meterid = ls_meter_itm-meterid
            %msg = new_message( id       = 'ZEM_MSG_22IT115'
                                number   = 003
                                v1       = 'Reading Not Found'
                                severity = if_abap_behv_message=>severity-error ) )
            TO reported-energymeteritm.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD delete.
    TYPES: BEGIN OF ty_itm,
             meterid   TYPE zem_de_meterid,
             readingno TYPE int2,
           END OF ty_itm.
    DATA ls_itm TYPE ty_itm.
    DATA(lo_util) = zcl_emu_22it115=>get_instance( ).
    LOOP AT keys INTO DATA(ls_key).
      CLEAR ls_itm.
      ls_itm-meterid   = ls_key-meterid.
      ls_itm-readingno = ls_key-ReadingNo.
      lo_util->set_itm_t_deletion( im_meter_info = ls_itm ).
      APPEND VALUE #( %cid      = ls_key-%cid_ref
                      meterid   = ls_key-meterid
                      readingno = ls_key-ReadingNo
        %msg = new_message( id       = 'ZEM_MSG_22IT115'
                            number   = 001
                            v1       = 'Reading Deleted Successfully'
                            severity = if_abap_behv_message=>severity-success ) )
        TO reported-energymeteritm.
    ENDLOOP.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD rba_EnergyHeader.
  ENDMETHOD.
ENDCLASS.

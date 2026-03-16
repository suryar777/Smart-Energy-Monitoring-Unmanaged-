CLASS lhc_EnergyMeterHdr DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations
      FOR EnergyMeterHdr RESULT result.
    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations
      FOR EnergyMeterHdr RESULT result.
    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE EnergyMeterHdr.
    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE EnergyMeterHdr.
    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE EnergyMeterHdr.
    METHODS read FOR READ
      IMPORTING keys FOR READ EnergyMeterHdr RESULT result.
    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK EnergyMeterHdr.
    METHODS rba_EnergyReading FOR READ
      IMPORTING keys_rba FOR READ EnergyMeterHdr\_EnergyReading
      FULL result_requested RESULT result LINK association_links.
    METHODS cba_EnergyReading FOR MODIFY
      IMPORTING entities_cba FOR CREATE EnergyMeterHdr\_EnergyReading.
ENDCLASS.

CLASS lhc_EnergyMeterHdr IMPLEMENTATION.
  METHOD get_instance_authorizations. ENDMETHOD.
  METHOD get_global_authorizations.   ENDMETHOD.
  METHOD lock.                        ENDMETHOD.

  METHOD create.
    DATA ls_meter_hdr TYPE zem_hdr_22it115.
    LOOP AT entities INTO DATA(ls_entities).
      ls_meter_hdr = CORRESPONDING #( ls_entities MAPPING FROM ENTITY ).
      IF ls_meter_hdr-meterid IS NOT INITIAL.
        SELECT FROM zem_hdr_22it115 FIELDS *
          WHERE meterid = @ls_meter_hdr-meterid
          INTO TABLE @DATA(lt_hdr).
        IF sy-subrc NE 0.
          DATA(lo_util) = zcl_emu_22it115=>get_instance( ).
          lo_util->set_hdr_value(
            EXPORTING im_meter_hdr = ls_meter_hdr
            IMPORTING ex_created   = DATA(lv_created) ).
          IF lv_created EQ abap_true.
            APPEND VALUE #( %cid    = ls_entities-%cid
                            meterid = ls_meter_hdr-meterid )
              TO mapped-energymeterhdr.
            APPEND VALUE #( %cid    = ls_entities-%cid
                            meterid = ls_meter_hdr-meterid
              %msg = new_message( id       = 'ZEM_MSG_22IT115'
                                  number   = 001
                                  v1       = 'Meter Created Successfully'
                                  severity = if_abap_behv_message=>severity-success ) )
              TO reported-energymeterhdr.
          ENDIF.
        ELSE.
          APPEND VALUE #( %cid    = ls_entities-%cid
                          meterid = ls_meter_hdr-meterid )
            TO failed-energymeterhdr.
          APPEND VALUE #( %cid    = ls_entities-%cid
                          meterid = ls_meter_hdr-meterid
            %msg = new_message( id       = 'ZEM_MSG_22IT115'
                                number   = 002
                                v1       = 'Duplicate Meter ID'
                                severity = if_abap_behv_message=>severity-error ) )
            TO reported-energymeterhdr.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD update.
    DATA ls_meter_hdr TYPE zem_hdr_22it115.
    LOOP AT entities INTO DATA(ls_entities).
      ls_meter_hdr = CORRESPONDING #( ls_entities MAPPING FROM ENTITY ).
      IF ls_meter_hdr-meterid IS NOT INITIAL.
        SELECT FROM zem_hdr_22it115 FIELDS *
          WHERE meterid = @ls_meter_hdr-meterid
          INTO TABLE @DATA(lt_hdr).
        IF sy-subrc EQ 0.
          DATA(lo_util) = zcl_emu_22it115=>get_instance( ).
          lo_util->set_hdr_value(
            EXPORTING im_meter_hdr = ls_meter_hdr
            IMPORTING ex_created   = DATA(lv_created) ).
          IF lv_created EQ abap_true.
            APPEND VALUE #( meterid = ls_meter_hdr-meterid )
              TO mapped-energymeterhdr.
            APPEND VALUE #( %key = ls_entities-%key
              %msg = new_message( id       = 'ZEM_MSG_22IT115'
                                  number   = 001
                                  v1       = 'Meter Updated Successfully'
                                  severity = if_abap_behv_message=>severity-success ) )
              TO reported-energymeterhdr.
          ENDIF.
        ELSE.
          APPEND VALUE #( %cid    = ls_entities-%cid_ref
                          meterid = ls_meter_hdr-meterid )
            TO failed-energymeterhdr.
          APPEND VALUE #( %cid    = ls_entities-%cid_ref
                          meterid = ls_meter_hdr-meterid
            %msg = new_message( id       = 'ZEM_MSG_22IT115'
                                number   = 003
                                v1       = 'Meter Not Found'
                                severity = if_abap_behv_message=>severity-error ) )
            TO reported-energymeterhdr.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD delete.
    TYPES: BEGIN OF ty_hdr,
             meterid TYPE zem_de_meterid,
           END OF ty_hdr.
    DATA ls_hdr TYPE ty_hdr.
    DATA(lo_util) = zcl_emu_22it115=>get_instance( ).
    LOOP AT keys INTO DATA(ls_key).
      CLEAR ls_hdr.
      ls_hdr-meterid = ls_key-meterid.
      lo_util->set_hdr_t_deletion( EXPORTING im_meter_doc = ls_hdr ).
      lo_util->set_hdr_deletion_flag( EXPORTING im_del = abap_true ).
      APPEND VALUE #( %cid    = ls_key-%cid_ref
                      meterid = ls_key-meterid
        %msg = new_message( id       = 'ZEM_MSG_22IT115'
                            number   = 001
                            v1       = 'Meter Deleted Successfully'
                            severity = if_abap_behv_message=>severity-success ) )
        TO reported-energymeterhdr.
    ENDLOOP.
  ENDMETHOD.

  METHOD read.
    LOOP AT keys INTO DATA(ls_key).
      SELECT SINGLE FROM zem_hdr_22it115 FIELDS *
        WHERE meterid = @ls_key-meterid
        INTO @DATA(ls_hdr).
      IF sy-subrc = 0.
        APPEND CORRESPONDING #( ls_hdr ) TO result.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD rba_EnergyReading.
    LOOP AT keys_rba INTO DATA(ls_key).
      SELECT FROM zem_itm_22it115 FIELDS *
        WHERE meterid = @ls_key-meterid
        INTO TABLE @DATA(lt_items).
      LOOP AT lt_items INTO DATA(ls_item).
        APPEND CORRESPONDING #( ls_item ) TO result.
        APPEND VALUE #( source-meterid   = ls_key-meterid
                        target-meterid   = ls_item-meterid
                        target-readingno = ls_item-readingno )
          TO association_links.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

  METHOD cba_EnergyReading.
    DATA ls_meter_itm TYPE zem_itm_22it115.
    LOOP AT entities_cba INTO DATA(ls_entities_cba).
      ls_meter_itm = CORRESPONDING #( ls_entities_cba-%target[ 1 ] ).
      IF ls_meter_itm-meterid IS NOT INITIAL
        AND ls_meter_itm-readingno IS NOT INITIAL.
        SELECT FROM zem_itm_22it115 FIELDS *
          WHERE meterid   = @ls_meter_itm-meterid
            AND readingno = @ls_meter_itm-readingno
          INTO TABLE @DATA(lt_itm).
        IF sy-subrc NE 0.
          DATA(lo_util) = zcl_emu_22it115=>get_instance( ).
          lo_util->set_itm_value(
            EXPORTING im_meter_itm = ls_meter_itm
            IMPORTING ex_created   = DATA(lv_created) ).
          IF lv_created EQ abap_true.
            APPEND VALUE #( %cid      = ls_entities_cba-%target[ 1 ]-%cid
                            meterid   = ls_meter_itm-meterid
                            readingno = ls_meter_itm-readingno )
              TO mapped-energymeteritm.
            APPEND VALUE #( %cid    = ls_entities_cba-%target[ 1 ]-%cid
                            meterid = ls_meter_itm-meterid
              %msg = new_message( id       = 'ZEM_MSG_22IT115'
                                  number   = 001
                                  v1       = 'Reading Created Successfully'
                                  severity = if_abap_behv_message=>severity-success ) )
              TO reported-energymeteritm.
          ENDIF.
        ELSE.
          APPEND VALUE #( %cid      = ls_entities_cba-%target[ 1 ]-%cid
                          meterid   = ls_meter_itm-meterid
                          readingno = ls_meter_itm-readingno )
            TO failed-energymeteritm.
          APPEND VALUE #( %cid    = ls_entities_cba-%target[ 1 ]-%cid
                          meterid = ls_meter_itm-meterid
            %msg = new_message( id       = 'ZEM_MSG_22IT115'
                                number   = 002
                                v1       = 'Duplicate Reading Number'
                                severity = if_abap_behv_message=>severity-error ) )
            TO reported-energymeteritm.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.

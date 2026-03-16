@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Child Interface View - Energy Readings'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZCI_EMI_22IT115
  as select from zem_itm_22it115
  association to parent ZCI_EMH_22IT115 as _EnergyHeader
    on $projection.MeterId = _EnergyHeader.MeterId
{
  key meterid               as MeterId,
  key readingno             as ReadingNo,
      readingdate           as ReadingDate,
      readingtime           as ReadingTime,
      @Semantics.quantity.unitOfMeasure: 'EnergyUnit'
      energyvalue           as EnergyValue,
      energyunit            as EnergyUnit,
      voltage               as Voltage,
      ampcurrent            as AmpCurrent,
      powerfactor           as PowerFactor,
      @Semantics.user.createdBy: true
      local_created_by      as LocalCreatedBy,
      @Semantics.systemDateTime.createdAt: true
      local_created_at      as LocalCreatedAt,
      @Semantics.user.lastChangedBy: true
      local_last_changed_by as LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,

      /* Associations */
      _EnergyHeader
}

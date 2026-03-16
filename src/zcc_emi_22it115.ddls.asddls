@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Energy Reading Item Consumption View'
@Search.searchable: true
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZCC_EMI_22IT115
  as projection on ZCI_EMI_22IT115
{
  key MeterId,
  key ReadingNo,
      @Search.defaultSearchElement: true
      ReadingDate,
      ReadingTime,
      @Semantics.quantity.unitOfMeasure: 'EnergyUnit'
      EnergyValue,
      EnergyUnit,
      Voltage,
      AmpCurrent,
      PowerFactor,
      LocalCreatedBy,
      LocalCreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,

      /* Associations */
      _EnergyHeader : redirected to parent ZCC_EMH_22IT115
}

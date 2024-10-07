reportextension 70010 "365 Phys. Inventory List" extends "Phys. Inventory List"
{
    RDLCLayout = './Procurement/9.Layout/PhysicalInventoryList.rdl';
    dataset
    {
        add("Item Journal Line")
        {
            column(PartNo; "Part No.")
            {
            }
            column(AlternativePartNo1; "Alternative Part No. 1")
            {
            }
            column(AlternativePartNo2; "Alternative Part No. 2")
            {
            }
            column(AlternativePartNo3; "Alternative Part No. 3")
            {
            }
        }
    }
}

page 50048 "Fixed Deposit Criteria"
{
    PageType = List;
    SourceTable = "FD Interest Calculation Crit1";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field("Minimum Amount"; Rec."Minimum Amount")
                {
                    ApplicationArea = All;
                }
                field("Maximum Amount"; Rec."Maximum Amount")
                {
                    ApplicationArea = All;
                }
                field("Interest Rate"; Rec."Interest Rate")
                {
                    ApplicationArea = All;
                }
                field(Duration; Rec.Duration)
                {
                    ApplicationArea = All;
                }
                field("On Call Interest Rate"; Rec."On Call Interest Rate")
                {
                    ApplicationArea = All;
                }
                field("No of Months"; Rec."No of Months")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}


pageextension 70007 "Purchase Invoice Subform EXT" extends "Purch. Invoice Subform"
{
    layout
    {
        addbefore("Shortcut Dimension 1 Code")
        {
            field("Service Date"; Rec."Service Date")
            {
                ApplicationArea = all;
                ToolTip = 'Service Date';
                ShowMandatory = true;
            }
            field("Part No."; Rec."Part No.")
            {
                ApplicationArea = all;
                ToolTip = 'Shows the Part No. of an item';
                ShowMandatory = true;
            }
            field("Alternative Part No. 1"; Rec."Alternative Part No. 1")
            {
                ApplicationArea = all;
                ToolTip = 'Shows the Alternative Part No. of an item';
                ShowMandatory = true;
            }
            field("Alternative Part No. 2"; Rec."Alternative Part No. 2")
            {
                ApplicationArea = all;
                ToolTip = 'Shows the Alternative Part No. of an item';
                ShowMandatory = true;
            }
            field("Alternative Part No. 3"; Rec."Alternative Part No. 3")
            {
                ApplicationArea = all;
                ToolTip = 'Shows the Alternative Part No. of an item';
                ShowMandatory = true;
            }
            field("Alternative Part No. 4"; Rec."Alternative Part No. 4")
            {
                ApplicationArea = all;
                ToolTip = 'Shows the Alternative Part No. of an item';
                ShowMandatory = true;
            }

        }
        modify("Shortcut Dimension 2 Code")
        {
            Visible = true;
        }
        modify("VAT Prod. Posting Group")
        {
            Visible = true;
        }
        modify("Gen. Prod. Posting Group")
        {
            Visible = true;
        }
    }
}

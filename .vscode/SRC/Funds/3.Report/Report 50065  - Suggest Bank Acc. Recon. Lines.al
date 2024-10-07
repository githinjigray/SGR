report 50065 "Suggest Bank Recon. Lines"
{
    Caption = 'Suggest Bank Acc. Recon. Lines';
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem("Bank Account"; "Bank Account")
        {
            DataItemTableView = SORTING("No.");

            trigger OnAfterGetRecord()
            begin
                BankAccLedgEntry.Reset;
                BankAccLedgEntry.SetCurrentKey("Bank Account No.", "Posting Date");
                BankAccLedgEntry.SetRange("Bank Account No.", "No.");
                BankAccLedgEntry.SetRange("Posting Date", StartDate, EndDate);
                BankAccLedgEntry.SetRange(Open, true);
                BankAccLedgEntry.SetRange("Statement Status", BankAccLedgEntry."Statement Status"::Open);
                if ExcludeReversedEntries then
                    BankAccLedgEntry.SetRange(Reversed, false);
                EOFBankAccLedgEntries := not BankAccLedgEntry.Find('-');

                if IncludeChecks then begin
                    CheckLedgEntry.Reset;
                    CheckLedgEntry.SetCurrentKey("Bank Account No.", "Check Date");
                    CheckLedgEntry.SetRange("Bank Account No.", "No.");
                    CheckLedgEntry.SetRange("Check Date", StartDate, EndDate);
                    CheckLedgEntry.SetFilter(
                      "Entry Status", '%1|%2', CheckLedgEntry."Entry Status"::Posted,
                      CheckLedgEntry."Entry Status"::"Financially Voided");
                    CheckLedgEntry.SetRange(Open, true);
                    CheckLedgEntry.SetRange("Statement Status", BankAccLedgEntry."Statement Status"::Open);
                    EOFCheckLedgEntries := not CheckLedgEntry.Find('-');
                end;

                while (not EOFBankAccLedgEntries) or (IncludeChecks and (not EOFCheckLedgEntries)) do
                    case true of
                        not IncludeChecks:
                            begin
                                EnterBankAccLine(BankAccLedgEntry);
                                EOFBankAccLedgEntries := BankAccLedgEntry.Next = 0;
                            end;
                        (not EOFBankAccLedgEntries) and (not EOFCheckLedgEntries) and
                        (BankAccLedgEntry."Posting Date" <= CheckLedgEntry."Check Date"):
                            begin
                                CheckLedgEntry2.Reset;
                                CheckLedgEntry2.SetCurrentKey("Bank Account Ledger Entry No.");
                                CheckLedgEntry2.SetRange("Bank Account Ledger Entry No.", BankAccLedgEntry."Entry No.");
                                CheckLedgEntry2.SetRange(Open, true);
                                if not CheckLedgEntry2.FindFirst then
                                    EnterBankAccLine(BankAccLedgEntry);
                                EOFBankAccLedgEntries := BankAccLedgEntry.Next = 0;
                            end;
                        (not EOFBankAccLedgEntries) and (not EOFCheckLedgEntries) and
                        (BankAccLedgEntry."Posting Date" > CheckLedgEntry."Check Date"):
                            begin
                                EnterCheckLine(CheckLedgEntry);
                                EOFCheckLedgEntries := CheckLedgEntry.Next = 0;
                            end;
                        (not EOFBankAccLedgEntries) and EOFCheckLedgEntries:
                            begin
                                CheckLedgEntry2.Reset;
                                CheckLedgEntry2.SetCurrentKey("Bank Account Ledger Entry No.");
                                CheckLedgEntry2.SetRange("Bank Account Ledger Entry No.", BankAccLedgEntry."Entry No.");
                                CheckLedgEntry2.SetRange(Open, true);
                                if not CheckLedgEntry2.FindFirst then
                                    EnterBankAccLine(BankAccLedgEntry);
                                EOFBankAccLedgEntries := BankAccLedgEntry.Next = 0;
                            end;
                        EOFBankAccLedgEntries and (not EOFCheckLedgEntries):
                            begin
                                EnterCheckLine(CheckLedgEntry);
                                EOFCheckLedgEntries := CheckLedgEntry.Next = 0;
                            end;
                    end;
            end;

            trigger OnPreDataItem()
            begin
                OnPreDataItemBankAccount(ExcludeReversedEntries);

                if EndDate = 0D then
                    Error(Text000);

                BankAccReconLine.FilterBankRecLines(BankAccRecon);
                if not BankAccReconLine.FindLast then begin
                    BankAccReconLine."Statement Type" := BankAccRecon."Statement Type";
                    BankAccReconLine."Bank Account No." := BankAccRecon."Bank Account No.";
                    BankAccReconLine."Statement No." := BankAccRecon."Statement No.";
                    BankAccReconLine."Statement Line No." := 0;
                end;

                SetRange("No.", BankAccRecon."Bank Account No.");
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    group("Statement Period")
                    {
                        Caption = 'Statement Period';
                        field(StartingDate; StartDate)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Starting Date';
                            ToolTip = 'Specifies the date from which the report or batch job processes information.';
                        }
                        field(EndingDate; EndDate)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Ending Date';
                            ToolTip = 'Specifies the date to which the report or batch job processes information.';
                        }
                    }
                    field(IncludeChecks; IncludeChecks)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Include Checks';
                        ToolTip = 'Specifies if you want the report to include check ledger entries. If you choose this option, check ledger entries are suggested instead of the corresponding bank account ledger entries.';
                    }
                    field(ExcludeReversedEntries; ExcludeReversedEntries)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Exclude Reversed Entries';
                        ToolTip = 'Specifies if you want to exclude reversed entries from the report.';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Text000: Label 'Enter the Ending Date.';
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
        CheckLedgEntry: Record "Check Ledger Entry";
        CheckLedgEntry2: Record "Check Ledger Entry";
        BankAccRecon: Record "Bank Acc. Reconciliation";
        BankAccReconLine: Record "Bank Acc. Reconciliation Line";
        BankAccSetStmtNo: Codeunit "Bank Acc. Entry Set Recon.-No.";
        CheckSetStmtNo: Codeunit "Check Entry Set Recon.-No.";
        StartDate: Date;
        EndDate: Date;
        IncludeChecks: Boolean;
        EOFBankAccLedgEntries: Boolean;
        EOFCheckLedgEntries: Boolean;
        ExcludeReversedEntries: Boolean;

    //[Scope('Personalization')]
    procedure SetStmt(var BankAccRecon2: Record "Bank Acc. Reconciliation")
    var
        BankEntry: Record "Bank Account Ledger Entry";
        BankRecLines: Record "Bank Acc. Reconciliation Line";
    begin
        BankAccRecon := BankAccRecon2;
        EndDate := BankAccRecon."Statement Date";

        BankEntry.RESET;
        BankEntry.SETRANGE(BankEntry."Bank Account No.", BankAccRecon."Bank Account No.");
        BankEntry.SETRANGE(BankEntry.Open, TRUE);
        BankEntry.SETRANGE(BankEntry."Statement Status", BankEntry."Statement Status"::"Bank Acc. Entry Applied");
        IF BankEntry.FINDSET THEN BEGIN
            REPEAT
                BankRecLines.RESET;
                BankRecLines.SETRANGE(BankRecLines."Bank Ledger Entry Line No", BankEntry."Entry No.");
                BankRecLines.SETRANGE(BankRecLines.Reconciled, TRUE);
                IF NOT BankRecLines.FINDFIRST THEN BEGIN
                    BankEntry."Statement Status" := BankEntry."Statement Status"::Open;
                    BankEntry."Statement No." := '';
                    BankEntry."Statement Line No." := 0;
                    BankEntry.MODIFY;
                END;
            UNTIL BankEntry.NEXT = 0;
        END;

        COMMIT;
    end;

    local procedure EnterBankAccLine(var BankAccLedgEntry2: Record "Bank Account Ledger Entry")
    begin
        BankAccReconLine.Init;
        BankAccReconLine."Statement Line No." := BankAccReconLine."Statement Line No." + 10000;
        BankAccReconLine."Transaction Date" := BankAccLedgEntry2."Posting Date";
        BankAccReconLine.Description := CopyStr(BankAccLedgEntry2.Description, 1, 100);
        BankAccReconLine."Document No." := CopyStr(BankAccLedgEntry2."Document No.", 1, 20);
        BankAccReconLine."Check No." := CopyStr(BankAccLedgEntry2."External Document No.", 1, 20);
        BankAccReconLine."Bank Ledger Entry Line No" := BankAccLedgEntry2."Entry No.";
        BankAccReconLine."Statement Amount" := BankAccLedgEntry2."Remaining Amount";
        BankAccReconLine.Difference := BankAccReconLine."Statement Amount";
        // BankAccReconLine.Type := BankAccReconLine.Type::"Bank Account Ledger Entry";
        //BankAccReconLine."Applied Entries" := 1;
        BankAccSetStmtNo.SetReconNo(BankAccLedgEntry2, BankAccReconLine);
        BankAccReconLine.Insert;
    end;

    local procedure EnterCheckLine(var CheckLedgEntry3: Record "Check Ledger Entry")
    begin
        BankAccReconLine.Init;
        BankAccReconLine."Statement Line No." := BankAccReconLine."Statement Line No." + 10000;
        BankAccReconLine."Transaction Date" := CheckLedgEntry3."Check Date";
        BankAccReconLine.Description := CheckLedgEntry3.Description;
        BankAccReconLine."Statement Amount" := -CheckLedgEntry3.Amount;
        BankAccReconLine."Applied Amount" := BankAccReconLine."Statement Amount";
        // BankAccReconLine.Type := BankAccReconLine.Type::"Check Ledger Entry";
        BankAccReconLine."Check No." := CheckLedgEntry3."Check No.";
        //BankAccReconLine."Applied Entries" := 1;
        CheckSetStmtNo.SetReconNo(CheckLedgEntry3, BankAccReconLine);
        BankAccReconLine.Insert;
    end;

    // [Scope('Personalization')]
    procedure InitializeRequest(NewStartDate: Date; NewEndDate: Date; NewIncludeChecks: Boolean)
    begin
        StartDate := NewStartDate;
        EndDate := NewEndDate;
        IncludeChecks := NewIncludeChecks;
        ExcludeReversedEntries := false;
    end;

    [IntegrationEvent(false, false)]
    procedure OnPreDataItemBankAccount(var ExcludeReversedEntries: Boolean)
    begin
        // ExcludeReversedEntries = FALSE by default
    end;
}


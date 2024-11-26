report 50010 "MPESA  Export File"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/src/Funds/12.layout/MPESA  Export File.rdlc';
    ApplicationArea = all;

    dataset
    {
        dataitem("Payment Header"; "Payment Header")
        {
            RequestFilterFields = "Bank Account No.", "Posting Date", Status;
            column(PaymentMode_PaymentHeader; "Payment Header"."Payment Mode")
            {
            }
            column(TotalAmount_PaymentHeader; "Payment Header"."Total Amount")
            {
            }
            column(TotalAmountLCY_PaymentHeader; "Payment Header"."Total Amount(LCY)")
            {
            }
            column(VATAmount_PaymentHeader; "Payment Header"."VAT Amount")
            {
            }
            column(VATAmountLCY_PaymentHeader; "Payment Header"."VAT Amount(LCY)")
            {
            }
            column(BankAccountNo_PaymentHeader; "Payment Header"."Bank Account No.")
            {
            }
            column(BankAccountName_PaymentHeader; "Payment Header"."Bank Account Name")
            {
            }
            column(BankAccountBalance_PaymentHeader; "Payment Header"."Bank Account Balance")
            {
            }
            column(No_PaymentHeader; "Payment Header"."No.")
            {
            }
            column(DocumentType_PaymentHeader; "Payment Header"."Document Type")
            {
            }
            column(DocumentDate_PaymentHeader; "Payment Header"."Document Date")
            {
            }
            column(PostingDate_PaymentHeader; "Payment Header"."Posting Date")
            {
            }
            column(ReferenceNo_PaymentHeader; "Payment Header"."Reference No.")
            {
            }
            column(PayeeNo_PaymentHeader; "Payment Header"."Payee No.")
            {
            }
            column(PayeeName_PaymentHeader; "Payment Header"."Payee Name")
            {
            }
            column(PhoneNo; PhoneNo)
            {
            }
            column(AccountNo; AccountNo)
            {
            }
            column(BankAcc; BankAcc)
            {
            }
            column(BankCode; BankCode)
            {
            }
            column(SupplierBankAccount; SupplierBankAccount)
            {
            }
            column(Description_PaymentHeader; "Payment Header".Description)
            {
            }
            column(ReportDate; ReportDate)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if ReportDate = 0D then Error(Text101);




                Banks.Reset;
                if Banks.Get("Bank Account No.") then begin
                    AccountNo := Banks."Bank Account No.";
                end;


                Supplier.Reset;
                if Supplier.Get("Payee No.") then begin

                    //PhoneNo:=Supplier."MPESA/Paybill Account No.";
                end;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Bank Account"; BankAcc)
                {
                    TableRelation = "Bank Account";
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Processing Date"; ReportDate)
                {
                    ApplicationArea = All;
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
        BankAcc: Code[20];
        Text101: Label 'Kindly fill in  the M-PESA  processing Date';
        AccountNo: Code[30];
        Banks: Record "Bank Account";
        PhoneNo: Text;
        Supplier: Record Vendor;
        BankCode: Code[10];
        SupplierBankAccount: Code[30];
        ReportDate: Date;
}


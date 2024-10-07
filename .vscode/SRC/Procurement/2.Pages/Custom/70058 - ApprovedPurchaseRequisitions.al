page 70058 "Approved Purchase Requisitions"
{
    CardPageID = "Purchase Requisition Card";
    ApplicationArea = all;
    UsageCategory = Lists;
    PageType = List;
    ShowFilter = true;
    SourceTable = "Purchase Requisitions";
    SourceTableView = where(Status = const(Approved));
    PromotedActionCategoriesML = ENU = 'New,Process,Reports,Details,Approvals,Attachements,Category7_caption,Approvals,Category9_caption,Category10_caption,Category11_caption,Category12_caption,Category13_caption,Category14_caption,Category15_caption,Category16_caption,Category17_caption,Category18_caption,Category19_caption,Category20_caption';
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; rec."No.")
                {
                    ToolTip = 'Specifies the unique document number';
                }
                field("Document Date"; rec."Document Date")
                {
                    ToolTip = 'Specifies the date when the purchase requisition was created';
                }
                field(Budget; rec.Budget)
                {
                    ToolTip = 'Budget';
                }
                field(Description; rec.Description)
                {
                    ToolTip = 'Description';
                }
                field(Status; rec.Status)
                {
                    Editable = false;
                    ToolTip = 'Specifies the approval status for the purchase requisition';
                }
                field("User ID"; rec."User ID")
                {
                    ToolTip = 'Specifies the user who created the purchase requisition';
                }
                field(Amount; rec.Amount)
                {
                }
                field("Amount(LCY)"; rec."Amount(LCY)")
                {
                }
                field("VAT Amount"; rec."VAT Amount")
                {

                }
                field("VAT Amount(LCY)"; rec."VAT Amount(LCY)")
                {

                }
                field("Total Amount"; Rec."Total Amount")
                {
                    Editable = false;

                }
                field("Total Amount(LCY)"; rec."Total Amount(LCY)")
                {
                    Editable = false;

                }

                field("Global Dimension 1 Code"; rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 3 Code"; rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 4 Code"; rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 5 Code"; rec."Shortcut Dimension 5 Code")
                {
                    ApplicationArea = All;

                }
                field("Shortcut Dimension 6 Code"; rec."Shortcut Dimension 6 Code")
                {
                    ApplicationArea = All;
                }
                field("Assigned User ID"; rec."Assigned User ID")
                {
                    ApplicationArea = All;
                }
                field("Assigned By"; rec."Assigned By")
                {
                    ApplicationArea = All;
                }
                field("Replenishment PR"; rec."Replenishment PR")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control38; Links)
            {
                ApplicationArea = RecordLinks;
            }
            systempart(Control21; Notes)
            {
            }
            part(ApprovalFactBox; "Approval FactBox")
            {
                ApplicationArea = Advanced;
            }
            part(IncomingDocAttachFactBox; "Incoming Doc. Attach. FactBox")
            {
                ApplicationArea = Advanced;
                ShowFilter = false;
                Visible = false;
            }
            part(WorkflowStatus; "Workflow Status FactBox")
            {
                ApplicationArea = Suite;
                Editable = false;
                Enabled = false;
                ShowFilter = false;
                Visible = ShowWorkflowStatus;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Portal Document Attachments")
            {
                Image = MakeDiskette;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                RunObject = Page PortalDocuments;
                RunPageLink = "DocumentNo." = FIELD("No.");
            }
            action(ReOpen)
            {
                Caption = 'ReOpen';
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed.';
                Visible = false;

                trigger OnAction()
                begin
                    Rec.TestField("User ID", UserId);
                    if Confirm(Txt_003, false, Rec."No.") then begin
                        //ProcurementApprovalWorkflow.ReOpenPurchaseRequisitionHeader(Rec);
                    end;
                end;
            }
            group(RequestApproval)
            {
                Caption = 'Request Approval';
                action(Approvals)
                {
                    AccessByPermission = TableData "Approval Entry" = R;
                    ApplicationArea = Suite;
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category8;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    RunObject = Page "Approval Entries-Modified";
                    RunPageLink = "Document No." = FIELD("No.");
                    ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';

                    trigger OnAction()
                    var
                        WorkflowsEntriesBuffer: Record "Workflows Entries Buffer";
                    begin
                        //WorkflowsEntriesBuffer.RunWorkflowEntriesPage(RECORDID,DATABASE::"52137003",DocumentType::Requisition,"No.");
                    end;
                }
                action(SendApprovalRequest)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Send A&pproval Request';
                    Enabled = NOT OpenApprovalEntriesExist AND CanRequestApprovalForFlow;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category8;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Request approval of the document.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        Rec.TestField(Rec.Status, Rec.Status::Open);
                        ProcurementManagement.CheckPurchaseRequisitionMandatoryFields(Rec);

                        if PurchaseRequisitionApproval.CheckPurchaseRequisitionApprovalWorkflowEnabled(Rec) then
                            PurchaseRequisitionApproval.OnSendPurchaseRequisitionForApproval(Rec);
                    end;
                }
                action(CancelApprovalRequest)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = CanCancelApprovalForRecord OR CanCancelApprovalForFlow;
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category8;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Cancel the approval request.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
                    begin
                        PurchaseRequisitionApproval.OnCancelPurchaseRequisitionForApproval(Rec);
                        WorkflowWebhookMgt.FindAndCancel(Rec.RecordId);

                        CurrPage.Close
                    end;
                }
            }
            group("Report")
            {
                Caption = 'Report';
                action("Print Purchase Requisition")
                {
                    Caption = 'Print Purchase Requisition';
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    ToolTip = 'Prepare to print the document. A report request window where you can specify what to include on the print-out.';

                    trigger OnAction()
                    begin
                        PurchaseRequisitionHeader.Reset;
                        PurchaseRequisitionHeader.SetRange(PurchaseRequisitionHeader."No.", Rec."No.");
                        if PurchaseRequisitionHeader.FindFirst then begin
                            REPORT.RunModal(REPORT::"Purchase Requisition", true, false, PurchaseRequisitionHeader);
                        end;
                    end;
                }
            }
            group(IncomingDocument)
            {
                Caption = 'Incoming Document';
                Image = Documents;
                action(IncomingDocCard)
                {
                    ApplicationArea = Suite;
                    Caption = 'View Incoming Document';
                    Enabled = HasIncomingDocument;
                    Image = ViewOrder;
                    ToolTip = 'View any incoming document records and file attachments that exist for the entry or document, for example for auditing purposes';

                    trigger OnAction()
                    var
                        IncomingDocument: Record "Incoming Document";
                    begin
                        IncomingDocument.ShowCardFromEntryNo(Rec."Incoming Document Entry No.");
                    end;
                }
                action(SelectIncomingDoc)
                {
                    AccessByPermission = TableData "Incoming Document" = R;
                    ApplicationArea = Suite;
                    Caption = 'Select Incoming Document';
                    Image = SelectLineToApply;
                    ToolTip = 'Select an incoming document record and file attachment that you want to link to the entry or document.';

                    trigger OnAction()
                    var
                        IncomingDocument: Record "Incoming Document";
                    begin
                        Rec.Validate(Rec."Incoming Document Entry No.", IncomingDocument.SelectIncomingDocument(Rec."Incoming Document Entry No.", Rec.RecordId));
                    end;
                }
                action(IncomingDocAttachFile)
                {
                    ApplicationArea = Suite;
                    Caption = 'Create Incoming Document from File';
                    Ellipsis = true;
                    Enabled = CreateIncomingDocumentEnabled;
                    Image = Attach;
                    ToolTip = 'Create an incoming document from a file that you select from the disk. The file will be attached to the incoming document record.';

                    trigger OnAction()
                    var
                        IncomingDocumentAttachment: Record "Incoming Document Attachment";
                    begin
                        //IncomingDocumentAttachment.NewAttachmentFromPurchaseRequisitionDocument(Rec);
                    end;
                }
                action(RemoveIncomingDoc)
                {
                    ApplicationArea = Suite;
                    Caption = 'Remove Incoming Document';
                    Enabled = HasIncomingDocument;
                    Image = RemoveLine;
                    ToolTip = 'Remove any incoming document records and file attachments.';

                    trigger OnAction()
                    var
                        IncomingDocument: Record "Incoming Document";
                    begin
                        if IncomingDocument.Get(Rec."Incoming Document Entry No.") then
                            IncomingDocument.RemoveLinkToRelatedRecord;
                        Rec."Incoming Document Entry No." := 0;
                        Rec.Modify(true);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetControlAppearance;
        //CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
        CurrPage.ApprovalFactBox.PAGE.UpdateApprovalEntriesFromSourceRecord(Rec.RecordId);
        ShowWorkflowStatus := CurrPage.WorkflowStatus.PAGE.SetFilterOnWorkflowRecord(Rec.RecordId);

        if Rec.Status = Rec.Status::Approved then
            CurrPage.Editable := false;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        /*PurchaseRequisitionHeader.RESET;
        PurchaseRequisitionHeader.SETRANGE("User ID",USERID);
        PurchaseRequisitionHeader.SETRANGE(Status,PurchaseRequisitionHeader.Status::Open);
        IF PurchaseRequisitionHeader.FINDFIRST THEN BEGIN
          ERROR(Txt_002);
        END;*/

    end;

    trigger OnOpenPage()
    begin
        //SETRANGE("User ID",USERID);
    end;

    var
        Txt_002: Label 'There is an open purchase requisition under your name, use it before you create a new one';
        ProcurementManagement: Codeunit "Procurement Management";
        ProcurementApprovalWorkflow: Codeunit "Procurement Approval Manager";
        PurchaseRequisitionHeader: Record "Purchase Requisitions";
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"," ",Payment,Receipt,Imprest,"Imprest Surrender","Funds Refund","Purchase Requisition",Requisition;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanRequestApprovalForFlow: Boolean;
        CanCancelApprovalForRecord: Boolean;
        CanCancelApprovalForFlow: Boolean;
        HasIncomingDocument: Boolean;
        CreateIncomingDocumentEnabled: Boolean;
        ShowWorkflowStatus: Boolean;
        Txt_003: Label 'Reopen Purchase Requisition Header Requisition No.:%1';
        PurchaseRequisitionApproval: Codeunit "Purchase Requisition Approval";
        PurchaseRequisitionLine: Record "Purchase Requisition Line";

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
    begin
        HasIncomingDocument := Rec."Incoming Document Entry No." <> 0;
        CreateIncomingDocumentEnabled := (not HasIncomingDocument) and (Rec."No." <> '');

        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RecordId);

        WorkflowWebhookMgt.GetCanRequestAndCanCancel(Rec.RecordId, CanRequestApprovalForFlow, CanCancelApprovalForFlow);
    end;
}
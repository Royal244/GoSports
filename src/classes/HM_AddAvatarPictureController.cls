public with sharing class HM_AddAvatarPictureController {
    public Blob pictureFile { get; set; }
    public Boolean visiblePicture { get; set; }
    public String urlImg { get; set; }
    public Doctor__c doctor { get; set; }
    public Attachment attachment { get; set; }

    public HM_AddAvatarPictureController(ApexPages.StandardController stdController) {
        this.visiblePicture = false;
        setLastAttachment();
    }

    public void loadPicture() {
        visiblePicture = true;
    }

    public void deleteImages() {
        String doctorId = ApexPages.currentPage().getParameters().get('Id');
        List<Attachment> attachments = [
                SELECT Id
                FROM Attachment
                WHERE ParentId = :doctorId
        ];
        delete attachments;
        setLastAttachment();
    }

    public void setLastAttachment() {
        String doctorId = ApexPages.currentPage().getParameters().get('Id');
        List<Attachment> attachments = [
                SELECT Id
                FROM Attachment
                WHERE ParentId = :doctorId
                ORDER BY LastModifiedDate DESC
                LIMIT 1
        ];
        if (!attachments.isEmpty()) {
            attachment = attachments[0];
        }else {
            attachment = new Attachment();
        }
    }

    @RemoteAction public static PageReference saveImage(String name, String contentType, String data, String parent) {
        Attachment attachedPhoto = new Attachment(Name = name, OwnerId = UserInfo.getUserId(),
                ContentType = contentType, Body = EncodingUtil.base64Decode(data), ParentId = parent);
        Database.insert(attachedPhoto, true);
        return null;
    }
}
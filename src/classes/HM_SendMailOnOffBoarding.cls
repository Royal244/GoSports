public class HM_SendMailOnOffBoarding implements Database.Batchable<sObject>, Database.Stateful {
    List<Doctor__c> newDoctors = new List<Doctor__c>();
    List<Doctor__c> oldDoctors = new List<Doctor__c>();
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
                'SELECT Id, Start_Date__c, End_Date__c, Doctor__c, Doctor__r.Name, Doctor__r.Last_Name__c, Doctor__r.E_mail_Adress__c, Doctor__r.Telephone_Number__c ' +
                        'FROM Contract__c WHERE Start_Date__c = TODAY OR End_Date__c = TODAY'
        );
    }
    public void execute(Database.BatchableContext bc, List<Contract__c> records) {
        Doctor__c doctor = new Doctor__c();
        for (Contract__c contract : records) {
            if (contract.Start_Date__c == Date.today()) {
                newDoctors.add(contract.Doctor__r);
            }else if (contract.End_Date__c == Date.today()) {
                oldDoctors.add(contract.Doctor__r);
            }
        }
    }
    public void finish(Database.BatchableContext bc) {
        if (newDoctors.size()>0) {
            EmailTemplate et = [SELECT Id FROM EmailTemplate WHERE Name = 'Onboarding'];
            sendEmail(newDoctors, et,'Onboarding Doctors.csv');
        }
        if (oldDoctors.size()>0) {
            EmailTemplate et = [SELECT Id FROM EmailTemplate WHERE Name = 'HM_Offboarding'];
            sendEmail(oldDoctors, et, 'Offboarding Doctors.csv');
        }
    }

    private void sendEmail(List<Doctor__c> doctors, EmailTemplate et, String fileName){
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setTargetObjectId(System.UserInfo.getUserId());
        List<String> addresses = new List<String>();
        addresses.add('daniel.siemienczuk@britenet.com.pl');
        addresses.add('jakub.katny@britenet.com.pl');
        message.setSenderDisplayName('Company Support');
        message.setReplyTo('no-reply@company.com');
        message.setUseSignature(false);
        message.setBccSender(false);
        message.setSaveAsActivity(false);
        message.setTemplateID(et.Id);
        message.toAddresses = addresses;
        String doctorsListToString = 'First_Name,Last_Name,Telephone_number,E-mail\n';
        for (Doctor__c doctor : doctors) {
            doctorsListToString += doctor.Name + ',';
            doctorsListToString += doctor.Last_Name__c + ',';
            doctorsListToString += doctor.Telephone_Number__c + ',';
            doctorsListToString += doctor.E_mail_Adress__c + '\n';
        }
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.fileName = fileName;
        efa.setBody(Blob.valueOf(doctorsListToString));
        message.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
    }
}
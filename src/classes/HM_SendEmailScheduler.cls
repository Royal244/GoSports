global class HM_SendEmailScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        HM_SendMailOnOffBoarding boarding = new HM_SendMailOnOffBoarding();
        database.executebatch(boarding);
    }
}
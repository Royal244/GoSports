public with sharing class MM_GetCastCalloutResponse {
    public Integer id;	//497698
    @AuraEnabled
    public cls_cast[] cast_z;
    @AuraEnabled
    public cls_crew[] crew;
    class cls_cast {
        public boolean adult;
        public Integer gender;	//1
        @AuraEnabled
        public Integer id;	//1245
        public String known_for_department;	//Acting
        @AuraEnabled
        public String name;	//Scarlett Johansson
        public String original_name;	//Scarlett Johansson
        public Double popularity;	//84.644
        @AuraEnabled
        public String profile_path;	///6NsMbJXRlDZuDzatN2akFdGuTvx.jpg
        public Integer cast_id;	//3
        @AuraEnabled
        public String character;	//Natasha Romanoff / Black Widow
        public String credit_id;	//5a57030fc3a3685ed703622e
        public Integer order;	//0
    }
    class cls_crew {
        public boolean adult;
        public Integer gender;	//1
        public Integer id;	//1245
        public String known_for_department;	//Acting
        public String name;	//Scarlett Johansson
        public String original_name;	//Scarlett Johansson
        public Double popularity;	//84.644
        public String profile_path;	///6NsMbJXRlDZuDzatN2akFdGuTvx.jpg
        public String credit_id;	//5cc8c2c192514119e5f848aa
        public String department;	//Production
        public String job;	//Executive Producer
    }
}
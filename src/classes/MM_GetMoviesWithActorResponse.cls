public with sharing class MM_GetMoviesWithActorResponse {
    @AuraEnabled
    public cls_cast[] cast_z;
//    public cls_crew[] crew;
    public Integer id;	//1245
    class cls_cast {
        public boolean adult;
        public String backdrop_path;	///tuiupUeJrNQkmO6LADHOSjbGJ6E.jpg
//        public cls_genre_ids[] genre_ids;
        @AuraEnabled
        public Integer id;	//3635
        public String original_language;	//en
        @AuraEnabled
        public String original_title;	//Girl with a Pearl Earring
        @AuraEnabled
        public String overview;	//This film, adapted from a work of fiction by author Tracy Chevalier, tells a story about the events surrounding the creation of the painting "Girl With A Pearl Earring" by 17th century Dutch master Johannes Vermeer. A young peasant maid working in the house of painter Johannes Vermeer becomes his talented assistant and the model for one of his most famous works.
        @AuraEnabled
        public String poster_path;	///nOZyq3GLpjsWWaB0PD3wjpzNNZq.jpg
        @AuraEnabled
        public String release_date;	//2003-12-12
        @AuraEnabled
        public String title;	//Girl with a Pearl Earring
        public boolean video;
        public Double vote_average;	//6.6
        public Integer vote_count;	//1054
        public Double popularity;	//8.744
        public String character;	//Griet
        public String credit_id;	//52fe43a1c3a36847f80632bd
        public Integer order;	//0
    }
}

public with sharing class MM_GetMoviesCalloutResponse {
    public Integer page;	//1
    @AuraEnabled
    public cls_results[] results;
    @AuraEnabled
    public Integer total_pages;	//3
    public Integer total_results;	//4
    public class cls_results {
        @AuraEnabled
        public Boolean favorite;
        @AuraEnabled
        public Boolean blackListed;
        public boolean adult;
        @AuraEnabled
        public String backdrop_path;	///7RyHsO4yDXtBv1zUU3mTpHeQ0d5.jpg
        public List<Integer> genre_ids;
        @AuraEnabled
        public Integer id;	//299534
        public String original_language;	//en
        @AuraEnabled
        public String original_title;	//Avengers: Endgame
        @AuraEnabled
        public String overview;	//After the devastating events of Avengers: Infinity War, the universe is in ruins due to the efforts of the Mad Titan, Thanos. With the help of remaining allies, the Avengers must assemble once more in order to undo Thanos' actions and restore order to the universe once and for all, no matter what consequences may be in store.
        public Double popularity;	//269.543
        @AuraEnabled
        public String poster_path;	///or06FN3Dka5tukK1e9sl16pB3iy.jpg
        @AuraEnabled
        public String release_date;	//2019-04-24
        @AuraEnabled
        public String title;	//Avengers: Endgame
        public boolean video;
        public Double vote_average;	//8.3
        public Integer vote_count;	//18618

        public cls_results(){
        }
    }

}
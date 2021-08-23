public with sharing class MM_ApiServiceTheMovieDB {

    private static HttpResponse createResponse(HttpRequest request) {
        HttpResponse response = new Http().send(request);
        return response;
    }
    @AuraEnabled
    public static MM_GetMoviesCalloutResponse getMovies(String searchString) {
        MM_GetMoviesCalloutResponse calloutResponse = new MM_GetMoviesCalloutResponse();
        String endPoint = 'https://api.themoviedb.org/3/search/movie?api_key=108ec159205c7b5a87e1c743ff61dbe8&language=en-US&query=' + searchString + '&include_adult=false';
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        request.setMethod('GET');
        request.setEndpoint(endPoint);
        response = createResponse(request);
        calloutResponse = (MM_GetMoviesCalloutResponse) JSON.deserialize(response.getBody(), MM_GetMoviesCalloutResponse.class);
        gowno(calloutResponse);
//        System.debug('Response: ' + JSON.deserialize(response.getBody(), MM_GetMoviesCalloutResponse.class));
        System.debug(JSON.serializePretty(calloutResponse));
        return calloutResponse;
    }

    private static void gowno(MM_GetMoviesCalloutResponse response) {
        Set<String> movieIds = new Set<String>();
        for (MM_GetMoviesCalloutResponse.cls_results chujowyTyp : response.results) {
            movieIds.add(String.valueOf(chujowyTyp.id));
        }
        List<favoriteOrBlackListMovie__c> chujowaNazwaTabeli = [
                SELECT Id, wherePutIt__c, MovieId__c
                FROM favoriteOrBlackListMovie__c
                WHERE MovieId__c in :movieIds
//                AND AccountId__c = IdCurrentUsera
        ];

        Map<String, List<String>> chujowaNazwaTabeliIdPlusChujowaNazwaPolaGdzieUmiescicFilm = new Map<String, List<String>>();
        for (favoriteOrBlackListMovie__c favoriteOrBlackListMovie : chujowaNazwaTabeli) {
            if (!chujowaNazwaTabeliIdPlusChujowaNazwaPolaGdzieUmiescicFilm.containsKey(favoriteOrBlackListMovie.MovieId__c)) {
                chujowaNazwaTabeliIdPlusChujowaNazwaPolaGdzieUmiescicFilm.put(favoriteOrBlackListMovie.MovieId__c, new List<String>());
            }
            chujowaNazwaTabeliIdPlusChujowaNazwaPolaGdzieUmiescicFilm.get(favoriteOrBlackListMovie.MovieId__c).add(favoriteOrBlackListMovie.wherePutIt__c);
        }

        for (MM_GetMoviesCalloutResponse.cls_results chujowyTyp : response.results) {
            if (chujowaNazwaTabeliIdPlusChujowaNazwaPolaGdzieUmiescicFilm.containsKey(String.valueOf(chujowyTyp.id))) {
                chujowyTyp.favorite = chujowaNazwaTabeliIdPlusChujowaNazwaPolaGdzieUmiescicFilm.get(String.valueOf(chujowyTyp.id)).contains('Favorite');
                chujowyTyp.blackListed = chujowaNazwaTabeliIdPlusChujowaNazwaPolaGdzieUmiescicFilm.get(String.valueOf(chujowyTyp.id)).contains('Black list');
            }
        }
    }

    @AuraEnabled
    public static MM_GetMoviesCalloutResponse getPopularMovies() {
        MM_GetMoviesCalloutResponse calloutResponse = new MM_GetMoviesCalloutResponse();
        String endPoint = 'https://api.themoviedb.org/3/movie/popular?api_key=108ec159205c7b5a87e1c743ff61dbe8&language=en-US&page=1';
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        request.setMethod('GET');
        request.setEndpoint(endPoint);
        response = createResponse(request);
        calloutResponse = (MM_GetMoviesCalloutResponse) JSON.deserialize(response.getBody(), MM_GetMoviesCalloutResponse.class);
        gowno(calloutResponse);
//        calloutResponse.results[0].chuj = '123';
//        System.debug('Response: ' + JSON.deserialize(response.getBody(), MM_GetMoviesCalloutResponse.class));
        System.debug(JSON.serializePretty(calloutResponse));
        System.debug(calloutResponse);
        return calloutResponse;
    }

    @AuraEnabled
    public static String getTrailer(String id) {
        MM_GetTrailerCalloutResponse calloutResponse = new MM_GetTrailerCalloutResponse();
        String endPoint = 'https://api.themoviedb.org/3/movie/' + id + '/videos?api_key=108ec159205c7b5a87e1c743ff61dbe8&language=en-US';
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        request.setMethod('GET');
        request.setEndpoint(endPoint);
        response = createResponse(request);
        calloutResponse = (MM_GetTrailerCalloutResponse) JSON.deserialize(response.getBody(), MM_GetTrailerCalloutResponse.class);
//        Object tmp = JSON.deserializeUntyped(response.getBody());
        System.debug('show me what u got: ' + calloutResponse.results[0].key);
        return calloutResponse.results[0].key;
    }

    @AuraEnabled
    public static MM_GetCastCalloutResponse getCast(String id) {
        MM_GetCastCalloutResponse calloutResponse = new MM_GetCastCalloutResponse();
        String endPoint = 'https://api.themoviedb.org/3/movie/' + id + '/credits?api_key=108ec159205c7b5a87e1c743ff61dbe8&language=en-US';
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        request.setMethod('GET');
        request.setEndpoint(endPoint);
        response = createResponse(request);
        calloutResponse = (MM_GetCastCalloutResponse) JSON.deserialize(response.getBody().replaceAll('cast', 'cast_z'), MM_GetCastCalloutResponse.class);
        return calloutResponse;
    }

    @AuraEnabled
    public static MM_GetMoviesWithActorResponse getMoviesWhereIsThisActor(String id) {
        MM_GetMoviesWithActorResponse calloutResponse = new MM_GetMoviesWithActorResponse();
        String endPoint = 'https://api.themoviedb.org/3/person/' + id + '/movie_credits?api_key=108ec159205c7b5a87e1c743ff61dbe8&language=en-US';
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        request.setMethod('GET');
        request.setEndpoint(endPoint);
        response = createResponse(request);
        calloutResponse = (MM_GetMoviesWithActorResponse) JSON.deserialize(response.getBody().replaceAll('cast', 'cast_z'), MM_GetMoviesWithActorResponse.class);
        System.debug(calloutResponse);
        return calloutResponse;
    }

    @AuraEnabled
    public static void addMovieToListOfFavorites(String movieId) {
        System.debug('movieID: ' + movieId);
        favoriteOrBlackListMovie__c whereMovie = new favoriteOrBlackListMovie__c();
        whereMovie.MovieId__c = movieId;
        whereMovie.AccountId__c = UserInfo.getUserId();
        whereMovie.wherePutIt__c = 'Favorite';
        List<favoriteOrBlackListMovie__c> movies = [
                SELECT wherePutIt__c, MovieId__c, AccountId__c
                FROM favoriteOrBlackListMovie__c
                WHERE AccountId__c = :whereMovie.AccountId__c AND MovieId__c = :whereMovie.MovieId__c
        ];
        if (movies.size() > 0) {
            if (movies[0].wherePutIt__c == 'Black list') {
                movies[0].wherePutIt__c = 'Favorite';
                update movies;
            }
        } else if (movies.size() < 1) {
            insert whereMovie;
        }

    }

    @AuraEnabled
    public static void addMovieToBlackList(String movieId) {
        favoriteOrBlackListMovie__c whereMovie = new favoriteOrBlackListMovie__c();
        whereMovie.MovieId__c = movieId;
        whereMovie.AccountId__c = UserInfo.getUserId();
        whereMovie.wherePutIt__c = 'Black list';
        List<favoriteOrBlackListMovie__c> movies = [
                SELECT wherePutIt__c, MovieId__c, AccountId__c
                FROM favoriteOrBlackListMovie__c
                WHERE AccountId__c = :whereMovie.AccountId__c AND MovieId__c = :whereMovie.MovieId__c
        ];
        if (movies.size() > 0) {
            if (movies[0].wherePutIt__c == 'Favorite') {
                movies[0].wherePutIt__c = 'Black list';
                update movies;
            }
        } else if (movies.size() < 1) {
            insert whereMovie;
        }
//        System.debug(whereMovie);
//        insert whereMovie;
    }

    @AuraEnabled
    public static MM_GetActorDetailsResponse getActorDetails(String id) {
        MM_GetActorDetailsResponse calloutResponse = new MM_GetActorDetailsResponse();
        String endPoint = 'https://api.themoviedb.org/3/person/' + id + '?api_key=108ec159205c7b5a87e1c743ff61dbe8&language=en-US';
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        request.setMethod('GET');
        request.setEndpoint(endPoint);
        response = createResponse(request);
        calloutResponse = (MM_GetActorDetailsResponse) JSON.deserialize(response.getBody(), MM_GetActorDetailsResponse.class);
        System.debug(calloutResponse);
        return calloutResponse;
    }

    @AuraEnabled
    public static MM_GetSingleMovieCalloutResponse getSingleMovieFromApi(String movieId) {
        MM_GetSingleMovieCalloutResponse calloutResponse = new MM_GetSingleMovieCalloutResponse();
        String endPoint = 'https://api.themoviedb.org/3/movie/' + movieId + '?api_key=108ec159205c7b5a87e1c743ff61dbe8&language=en-US';
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        request.setMethod('GET');
        request.setEndpoint(endPoint);
        response = createResponse(request);
        calloutResponse = (MM_GetSingleMovieCalloutResponse) JSON.deserialize(response.getBody(), MM_GetSingleMovieCalloutResponse.class);
//        System.debug(calloutResponse);
        return calloutResponse;
    }

    @AuraEnabled
    public static List<MM_GetSingleMovieCalloutResponse> getFavOrBlackList(String nameList) {
        List<MM_GetSingleMovieCalloutResponse> listCalloutResponse = new List<MM_GetSingleMovieCalloutResponse>();
        if (nameList == 'Favorite') {
            List<favoriteOrBlackListMovie__c> listMovies = [
                    SELECT wherePutIt__c, MovieId__c, AccountId__c
                    FROM favoriteOrBlackListMovie__c
                    WHERE AccountId__c = :UserInfo.getUserId() AND wherePutIt__c = 'Favorite'
            ];
            if (!listMovies.isEmpty()) {
                for (favoriteOrBlackListMovie__c movie : listMovies) {
                    MM_GetSingleMovieCalloutResponse movieToAdd = new MM_GetSingleMovieCalloutResponse();
                    movieToAdd = getSingleMovieFromApi(movie.MovieId__c);
                    listCalloutResponse.add(movieToAdd);
                }
            }
        } else if (nameList == 'Black list') {
            List<favoriteOrBlackListMovie__c> listMovies = [
                    SELECT wherePutIt__c, MovieId__c, AccountId__c
                    FROM favoriteOrBlackListMovie__c
                    WHERE AccountId__c = :UserInfo.getUserId() AND wherePutIt__c = 'Black list'
            ];
            if (!listMovies.isEmpty()) {
                for (favoriteOrBlackListMovie__c movie : listMovies) {
                    MM_GetSingleMovieCalloutResponse movieToAdd = new MM_GetSingleMovieCalloutResponse();
                    movieToAdd = getSingleMovieFromApi(movie.MovieId__c);
                    listCalloutResponse.add(movieToAdd);
                }
            }
        }
        System.debug(listCalloutResponse);
        isOnBlackListOrFavList(listCalloutResponse);
        return listCalloutResponse;
    }

    private static void isOnBlackListOrFavList(List<MM_GetSingleMovieCalloutResponse> filmList) {
        Set<String> movieIds = new Set<String>();
        for (MM_GetSingleMovieCalloutResponse film : filmList) {
            movieIds.add(String.valueOf(film.id));
        }
//        for (MM_GetMoviesCalloutResponse.cls_results chujowyTyp : response.results) {
//            movieIds.add(String.valueOf(chujowyTyp.id));
//        }
        List<favoriteOrBlackListMovie__c> chujowaNazwaTabeli = [
                SELECT Id, wherePutIt__c, MovieId__c
                FROM favoriteOrBlackListMovie__c
                WHERE MovieId__c in :movieIds
//                AND AccountId__c = IdCurrentUsera
        ];

        Map<String, List<String>> chujowaNazwaTabeliIdPlusChujowaNazwaPolaGdzieUmiescicFilm = new Map<String, List<String>>();
        for (favoriteOrBlackListMovie__c favoriteOrBlackListMovie : chujowaNazwaTabeli) {
            if (!chujowaNazwaTabeliIdPlusChujowaNazwaPolaGdzieUmiescicFilm.containsKey(favoriteOrBlackListMovie.MovieId__c)) {
                chujowaNazwaTabeliIdPlusChujowaNazwaPolaGdzieUmiescicFilm.put(favoriteOrBlackListMovie.MovieId__c, new List<String>());
            }
            chujowaNazwaTabeliIdPlusChujowaNazwaPolaGdzieUmiescicFilm.get(favoriteOrBlackListMovie.MovieId__c).add(favoriteOrBlackListMovie.wherePutIt__c);
        }

        for (MM_GetSingleMovieCalloutResponse film : filmList) {
            if (chujowaNazwaTabeliIdPlusChujowaNazwaPolaGdzieUmiescicFilm.containsKey(String.valueOf(film.id))) {
                film.favorite = chujowaNazwaTabeliIdPlusChujowaNazwaPolaGdzieUmiescicFilm.get(String.valueOf(film.id)).contains('Favorite');
                film.blackListed = chujowaNazwaTabeliIdPlusChujowaNazwaPolaGdzieUmiescicFilm.get(String.valueOf(film.id)).contains('Black list');
            }
        }

//        for (MM_GetMoviesCalloutResponse.cls_results chujowyTyp : response.results) {
//            if (chujowaNazwaTabeliIdPlusChujowaNazwaPolaGdzieUmiescicFilm.containsKey(String.valueOf(chujowyTyp.id))) {
//                chujowyTyp.favorite = chujowaNazwaTabeliIdPlusChujowaNazwaPolaGdzieUmiescicFilm.get(String.valueOf(chujowyTyp.id)).contains('Favorite');
//                chujowyTyp.blackListed = chujowaNazwaTabeliIdPlusChujowaNazwaPolaGdzieUmiescicFilm.get(String.valueOf(chujowyTyp.id)).contains('Black list');
//            }
//        }
    }

    @AuraEnabled
    public static MM_GetMoviesCalloutResponse getMoviesWithNumberOfPage(String searchString, Integer pageNumber) {
        MM_GetMoviesCalloutResponse calloutResponse = new MM_GetMoviesCalloutResponse();
        String endPoint = 'https://api.themoviedb.org/3/search/movie?api_key=108ec159205c7b5a87e1c743ff61dbe8&language=en-US&query=' + searchString + '&page=' + pageNumber + '&include_adult=false';
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        request.setMethod('GET');
        request.setEndpoint(endPoint);
        response = createResponse(request);
        calloutResponse = (MM_GetMoviesCalloutResponse) JSON.deserialize(response.getBody(), MM_GetMoviesCalloutResponse.class);
        gowno(calloutResponse);
//        System.debug('Response: ' + JSON.deserialize(response.getBody(), MM_GetMoviesCalloutResponse.class));
        System.debug(JSON.serializePretty(calloutResponse));
        return calloutResponse;
    }

    @AuraEnabled
    public static List<Movie_review__c> getMovieReviews(Integer id){
        List<Movie_review__c> movieReviews = new List<Movie_review__c>();
        movieReviews = [
                SELECT Id, Name, Rating__c, Comment__c, CreatedBy.Name, CreatedBy.SmallPhotoUrl, CreatedBy.CompanyName, CreatedDate, LastModifiedDate
                FROM Movie_review__c
                WHERE MovieId__c =: id
        ];
        return movieReviews;
    }


}
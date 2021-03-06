
a = angular.module 'tos.provider', []

a.provider '$tos', ->
    # ----------------------------------------
    # providers
    # ----------------------------------------
    $injector = null
    $http = null


    # ----------------------------------------
    # properties
    # ----------------------------------------
    @languages =
        ###
        All language codes.
        ###
        en: 'English'
        'zh-TW': '繁體中文'
    @currentLanguage = do =>
        ###
        The current language code.
        ###
        if @languages[navigator.language]?
            navigator.language
        else
            switch navigator.language
                when 'zh-CN', 'zh-HK' then 'zh-TW'
                else 'en'


    # ----------------------------------------
    # private functions
    # ----------------------------------------
    @setupProvider = (injector) ->
        $injector = injector
        $http = $injector.get '$http'

    @getResource = (url) =>
        h = $http
            method: 'get'
            url: url
            cache: yes
            transformResponse: [(data) ->
                eval data
            ].concat $http.defaults.transformResponse
        h.error ->
            console.log 'error'


    # ----------------------------------------
    # public functions
    # ----------------------------------------
    @getCards = =>
        ###
        Get all cards.
        @return: {$http}
            id: {int} The card id.
            name: {string} The card name.
            imageSm: {string} The small image url.
            race: {string} The card's race. [human, dragon, beast, elf, god, fiend, ee(evolve elements)]
            attribute: {string} The card's attribute. [light, dark, water, fire, wood]
        ###
        h = @getResource "data/#{@currentLanguage}/cards.min.js"
        h.then (response) ->
            response.data


    # ----------------------------------------
    # $get
    # ----------------------------------------
    @get = ($injector) ->
        @setupProvider $injector

        languages: @languages
        currentLanguage: @currentLanguage
        getCards: @getCards
    @get.inject = ['$injector']
    @$get = @get
    return

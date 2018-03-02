#%RAML 1.0
---
title: Jukebox API
baseUri: http://jukebox.api.com
version: v1

types:
 song: !include jukebox-include-song.schema
 artist: !include jukebox-include-artist.schema
 album: !include jukebox-include-album.schema


resourceTypes:
  readOnlyCollection:
    description: Collection of available <<resourcePathName>> in Jukebox.
    get:
      description: Get a list of <<resourcePathName>>.
      responses:
        200:
          body:
            application/json:
              example: |
                <<exampleCollection>>
  collection:
    description: Collection of available <<resourcePathName>> in Jukebox.
    get:
      description: Get a list of <<resourcePathName>>.
      responses:
        200:
          body:
            application/json:
              example: |
                <<exampleCollection>>
    post:
      description: |
        Add a new <<resourcePathName|!singularize>> to Jukebox.
      queryParameters:
        access_token:
          description: "The access token provided by the authentication application"
          example: AABBCCDD
          required: true
          type: string
      body:
        application/json:
          type: <<resourcePathName|!singularize>>
          example: |
            <<exampleItem>>
      responses:
        200:
          body:
            application/json:
              example: |
                { "message": "The <<resourcePathName|!singularize>> has been properly entered" }
  collection-item:
    description: Entity representing a <<resourcePathName|!singularize>>
    get:
      description: |
        Get the <<resourcePathName|!singularize>>
        with <<resourcePathName|!singularize>>Id =
        {<<resourcePathName|!singularize>>Id}
      responses:
        200:
          body:
            application/json:
              example: |
                <<exampleItem>>
        404:
          body:
            application/json:
              example: |
                {"message": "<<resourcePathName|!singularize>> not found" }
traits:
  searchable:
    queryParameters:
      query:
        description: |
          JSON array [{"field1","value1","operator1"},{"field2","value2","operator2"},...,{"fieldN","valueN","operatorN"}] <<description>>
        example: |
          <<example>>
  orderable:
    queryParameters:
      orderBy:
        description: |
          Order by field: <<fieldsList>>
        type: string
        required: false
      order:
        description: Order
        enum: [desc, asc]
        default: desc
        required: false
  pageable:
    queryParameters:
      offset:
        description: Skip over a number of elements by specifying an offset value for the query
        type: integer
        required: false
        example: 20
        default: 0
      limit:
        description: Limit the number of elements on the response
        type: integer
        required: false
        example: 80
        default: 10

/songs:
  type:
    collection:
      exampleCollection: !include jukebox-include-songs.sample
      exampleItem: !include jukebox-include-song-new.sample
  get:
    is: [
          searchable: {description: "with valid searchable fields: songTitle", example: "[\"songTitle\", \"Get L\", \"like\"]"},
          orderable: {fieldsList: "songTitle"},
          pageable
        ]
  /{songId}:
    type:
      collection-item:
        exampleItem: !include jukebox-include-song-retrieve.sample
    /file-content:
      description: The file to be reproduced by the client
      get:
        description: Get the file content
        responses:
          200:
            body:
              application/octet-stream:
                example:
                  !include heybulldog.mp3
      post:
        description: |
           Enters the file content for an existing song entity.

           The song needs to be created for the `/songs/{songId}/file-content` to exist.
           You can use this second resource to get and post the file to reproduce.

           Use the "binary/octet-stream" content type to specify the content from any consumer (excepting web-browsers).
           Use the "multipart-form/data" content type to upload a file which content will become the file-content
        body:
          application/octet-stream:
          multipart/form-data:
            properties:
              file:
                description: The file to be uploaded
                required: true
                type: file
/artists:
  type:
    collection:
      exampleCollection: !include jukebox-include-artists.sample
      exampleItem: !include jukebox-include-artist-new.sample
  get:
    is: [
          searchable: {description: "with valid searchable fields: countryCode", example: "[\"countryCode\", \"FRA\", \"equals\"]"},
          orderable: {fieldsList: "artistName, nationality"},
          pageable
        ]
  /{artistId}:
    type:
      collection-item:
        exampleItem: !include jukebox-include-artist-retrieve.sample
    /albums:
      type:
        readOnlyCollection:
          exampleCollection: !include jukebox-include-artist-albums.sample
      description: Collection of albulms belonging to the artist
      get:
        description: Get a specific artist's albums list
        is: [orderable: {fieldsList: "albumName"}, pageable]
/albums:
  type:
    collection:
      exampleCollection: !include jukebox-include-albums.sample
      exampleItem: !include jukebox-include-album-new.sample
  get:
    is: [
          searchable: {description: "with valid searchable fields: genreCode", example: "[\"genreCode\", \"ELE\", \"equals\"]"},
          orderable: {fieldsList: "albumName, genre"},
          pageable
        ]
  /{albumId}:
    type:
      collection-item:
        exampleItem: !include jukebox-include-album-retrieve.sample
    /songs:
      type:
        readOnlyCollection:
          exampleCollection: !include jukebox-include-album-songs.sample
      get:
        is: [orderable: {fieldsList: "songTitle"}]
        description: Get the list of songs for the album with `albumId = {albumId}`
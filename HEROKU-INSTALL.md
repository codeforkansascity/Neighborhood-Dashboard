Notes from Paul's install


[Update Ruby to Latest Version on Mac OS X – The Coding Pad](http://codingpad.maryspad.com/2017/04/29/update-mac-os-x-to-the-current-version-of-ruby/)

heroku create
Creating app... done, ⬢ pacific-fortress-82024
https://pacific-fortress-82024.herokuapp.com/ | https://git.heroku.com/pacific-fortress-82024.git

Arron: https://afternoon-crag-46310.herokuapp.com/ | https://git.heroku.com/afternoon-crag-46310.git

AIzaSyAXZbTnHGQ-80pXHD5TK_Rq7LDuTWZSVaE

AIzaSyCJnHS662l7UYK3EKYDwwuGtaFfnlc1qBU


https://pacific-fortress-82024.herokuapp.com/ deployed to Heroku

# [Getting Started on Heroku with Ruby \| Heroku Dev Center](https://devcenter.heroku.com/articles/getting-started-with-ruby)


```
    heroku login
```

```
    heroku create
    
Creating app... done, ⬢ blooming-crag-36791
https://blooming-crag-36791.herokuapp.com/ | https://git.heroku.com/blooming-crag-36791.git
```

Goto Google API and get a KEY and set it for the URL above.

1. Goto [Google Cloud Platform](https://console.cloud.google.com/getting-started)
2. Click APIs & Services -> Credentials
3. Select or Create depending if you have a key setup or not.
4. Update the following files with the API key
   * app/views/layouts/application.html.erb
   * lib/google_maps/static_generator.rb
   * spec/lib/google_maps/static_generator_spec.rb

```
    git push heroku master
```

GOOGLE API KEYS in two places

RAKE - set DB, Name, User, Password then ran 

```
    heroku run rake db:migrate db:seed
```

If it does not work try....

## Set Database enviroment variables

1. Goto Huruko Web Page
2. Clcik on the app
3. Goto Resources tab
4. Click on 'Heroku postress :: database'
5. Click on Settings tab
6. Click on View Credentials
7. Remember Credentials
8. Goto Huruko Web Page
9. Click on App
10. Click on Setting
11. Clcik on Reveal Config Vars
12. Add 
     * DATABASE_NAME
     * DATABASE_USER
     * DATABASE_PASSWORD

App should work now

 

[Google Maps shows "For development purposes only" - Stack Overflow](https://stackoverflow.com/questions/50977913/google-maps-shows-for-development-purposes-only)




```
--- a/app/views/layouts/application.html.erb
+++ b/app/views/layouts/application.html.erb
@@ -6,7 +6,7 @@
     <%= stylesheet_link_tag    'application', media: 'all' %>
     <%= csrf_meta_tags %>
     <meta name="viewport" content="width=device-width, initial-scale=1"/>
-    <script src="//maps.googleapis.com/maps/api/js?sensor=false&key=AIzaSyCvmxpgAeNj2rYwL54kqzkGSrvAvapNt4A"></script>
+    <script src="//maps.googleapis.com/maps/api/js?sensor=false&key=AIzaSyAOou3HcMJA52b4ZNVKD23RvYZEWDF9i1M"></script>
   </head>
   <body >
     <div id="root" class="application-wrapper"></div>
diff --git a/lib/google_maps/static_generator.rb b/lib/google_maps/static_generator.rb
index 06c5676..40fd537 100644


--- a/lib/google_maps/static_generator.rb
+++ b/lib/google_maps/static_generator.rb
@@ -15,7 +15,7 @@ module GoogleMaps
     private
 
     def api_key
-      '&key=AIzaSyCvmxpgAeNj2rYwL54kqzkGSrvAvapNt4A'
+      '&key=AIzaSyAOou3HcMJA52b4ZNVKD23RvYZEWDF9i1M'
     end
 
     def styles
     
     
--- a/spec/lib/google_maps/static_generator_spec.rb
+++ b/spec/lib/google_maps/static_generator_spec.rb
@@ -25,7 +25,7 @@ RSpec.describe GoogleMaps::StaticGenerator do
 
   describe '#generate_static_api_uri' do
     it 'includes the correct api key' do
-      expect(subject.generate_static_api_uri).to include('key=AIzaSyCvmxpgAeNj2rYwL54kqzkGSrvAvapNt4A')
+      expect(subject.generate_static_api_uri).to include('key=AIzaSyCJnHS662l7UYK3EKYDwwuGtaFfnlc1qBU')
     end
 
     it 'includes the correct size' do
@@ -78,4 +78,4 @@ RSpec.describe GoogleMaps::StaticGenerator do
       end
     end
   end
-end
\ No newline at end of file
+end
     
```


# alpine-perl-dancer2
Alpine base image with perl, dancer2 and support for connecting to Postgres databases.

I needed a small image for my Perl Dancer based projects but I figured someone might find this useful as well.

This image can be used as a development environment, let's say your dancer based web app is located on /home/fred/awesome-app
you could run it with this image using:
```docker run -it -p 5000:5000 -v /home/fred:/home/dancer giovesgo/alpine-perl-dancer2 /home/dancer/awesome-app ```

It could also be used as a base for a new image to include additional perl modules:
```
FROM giovesgo/alpine-perl-dancer2
cpanm YOUR-MODULE \
      YOUR-MODULE-2 \
      YOUR-MODULE-3
      
ENTRYPOINT ["starman"]
CMD ["MyWeb-App/bin/app.psgi"]
```


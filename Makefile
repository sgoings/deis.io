build:
	bundle exec jekyll build ./_site

deploy:
	bundle exec s3_website cfg apply
	bundle exec s3_website push --force

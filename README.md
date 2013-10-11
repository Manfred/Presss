# Presss

Presss uploads objects to and downloads objects from from Amazon S3. It's a tiny companion to a more complete implementation like AWS SDK.

## Install

You can install Presss as a Rubygem or directly from the Git repository if you prefer.

## Configure

You start by configuring Presss globally to use a certain bucket in a region with your credentials.

    Presss.config = {
      region: 'eu-west-1',
      bucket_name: 'my-bucket-name',
      access_key_id: 'access key ID',
      secret_access_key: 'access key secret'
    }

For valid regions see the AWS documentation. You can test if a region works by getting the hostname for it. In this example the region is `eu-west-1`.

    $ host s3-eu-west-1.amazonaws.com

## Upload files

The `put` method uploads anything that responds to either a `read` or `to_s` method. Currently the entire upload is stored in memory so it's not too great at uploading large files.

    File.open('as6745it.zip') do |file|
      Presss.put('books/12/as6745it.zip', file, 'application/zip')
    end

## Download files

The `get` methods downloads the remote object and stores it in a string. Like with the put method this doesn't make it ideal for downloading large files.

    Presss.get('books/12/as6745it.zip')

## Authors

* Manfred Stienstra
* Jeff Kreeftmeijer
* Eric Lindvall

## Copying

Presss is freely distributable under the terms of an MIT-style license. See COPYING or http://www.opensource.org/licenses/mit-license.php. When you contribute code to this project we assume you share it with the same license.
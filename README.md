# Presss

Presss uploads objects to and downloads objects from from Amazon S3. It's a tiny companion to a more complete implementation like AWS SDK.

## Upload files

The `put` method uploads anything that responds to either a `read` or `to_s` method. Currently the entire upload is stored in memory so it's not too great at uploading large files.

    File.open('as6745it.zip') do |file|
      Presss.put('books/12/as6745it.zip', file, 'application/zip')
    end

## Download files

The `get` methods downloads the remote object and stores it in a string. Like with the put method this doesn't make it ideal for downloading large files.

    Presss.get('books/12/as6745it.zip')

## Copying

Presss is freely distributable under the terms of an MIT-style license. See COPYING or http://www.opensource.org/licenses/mit-license.php.
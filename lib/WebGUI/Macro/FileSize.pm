package WebGUI::Macro::FileSize;

use strict;
use WebGUI::Asset;
use WebGUI::Storage;
use 5.010;

=head1 NAME

Package WebGUI::Macro::FileSize

=head1 DESCRIPTION

Macro to display the filesize on disk for the file in a file asset.

=head2 process( $session, url )

The macro takes a url of a file asset and looks up the file size.

=over 4

=item *

A session variable

=item *

Any other options that were sent to the macro by the user.  It is up to you to set defaults and
to validate user input.

=back

=cut


#-------------------------------------------------------------------
sub process {
	my $session = shift;
	my $url     = shift;

        my $asset   = WebGUI::Asset->newByUrl( $session, $url );
	return "" unless $asset->getValue( 'className' ) =~ /^WebGUI::Asset::File/;
        $asset->get("filename");
	my $fileUrl = $asset->getStorageLocation->getUrl( $asset->get( "filename" ) );
	my $store     = WebGUI::Storage->get( $session, $asset->get( "storageId" ) );
	my $size      = $store->getFileSize( $asset->get( "filename" ));
	given ( $size ) {
	    when( $size > 1073741824 ) { $size = $size / 1073741824 ;
					 $size = sprintf( "%.2f", $size ) . " Gb";}
	    when( $size >    1048576 ) { $size = $size /    1048576 ;
                                         $size = sprintf( "%.2f", $size ) . " Mb";}
	    when( $size >       1024 ) { $size = $size /       1024 ; 
					 $size = sprintf( "%.2f", $size ) . " Kb";}
	    default 		       { $size .= " byte"; }
	}

	return $size;
}

1;

#vim:ft=perl

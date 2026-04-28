#!/usr/bin/perl

die "Usage: perl SimpleFastaHeaders.pl <dirname/filename>\n" if @ARGV < 1;

HEADER($ARGV[0]) if -f $ARGV[0];

& READ_DIR if -d $ARGV[0];

sub READ_DIR {

  ($indir = $ARGV[0]) =~ s/\/$//;

  opendir(FASTADIR, $indir) || die "There is not a directory of that name in the path you specified. Please try again\n\n";

  @FASTA = readdir(FASTADIR);

  $Success = 'no';

  foreach $Fasta (@FASTA) {

    print "$Fasta\n";

    if($Fasta =~ /fasta|fsa|fa|fna|mfa$/) {

      HEADER($Fasta);

      $Success='yes'

    }
    else {
      die "Sequence file(s) must end with fasta|fsa|fa|fna|mfa suffix\n";
    }

  }

  close FASTADIR;

  die "No fasta files detected in specified directory. Genome assembly names must end in one of these suffixes: fasta|fsa|fa|fna|mfa\n" if $Success eq 'no';

}

  
sub HEADER {

  my $SeqNo = 0;

  my $Fasta = @_[0];

  @filepath = split(/\//, $Fasta);

  $Genome_ID = $filepath[-1];

  $Genome_ID =~ s/_.+|\..+//;

  if(@ARGV == 2) {

    $Genome_ID = $ARGV[1];

    $outfile = $Genome_ID."_newheader.fasta";

    print "$outfile\n";

  }

  else {

    print "$Fasta\n";

    ($outfile = $Fasta) =~ s/.+\///;		# Strip off file path

    $outfile =~ s/_.*/_newheader.fasta/;	

    print "$outfile\n";

  }

  open(FASTAOUT, '>', "$outfile") || die "Problem creating corrected genome file: $!\n";

  open(MAPOUT, '>', "$Genome_ID"."_contig_map.txt") || die "Problem creating contig mapping file\n" ;

  print MAPOUT "Old-genomeID\tNew-genomeID\n$oldGenome_ID\t$Genome_ID\nNew_ID\t\tOld_ID\n$oldGenome_ID\t$Genome_ID\n";

  print "Re-naming sequence headers for easy parsing in downstream applications\n";

  open(FASTA, "$Fasta");

  while($Line = <FASTA>) {

    if($Line =~ /^>/) {

      $SeqNo ++;

      print FASTAOUT ">$Genome_ID"."_contig$SeqNo\n";

      $Line =~ s/^>//;

      print MAPOUT "$Genome_ID"."_contig$SeqNo\t$Line"

    }

    else {

      print FASTAOUT "$Line"

    }

  }

  close FASTA;

  close FASTAOUT;

  close MAPOUT;

  print   "\n########################################################\n\n".
        "Sequence headers have been converted and written to the file: $outfile\n".
	"Mapping between new and old sequence IDs was written to the file: $Genome_ID"."_contig_map.txt\n\n"

}

print "Conversion(s) finished.\n";

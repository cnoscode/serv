require 'rubygems'
require 'bio'

fq = Bio::FlatFile.open('test1.fastq')

file_ctr = 0
fqeq = File.new("/Users/cjose/blat/fq#{file_ctr}_out.fa", 'w')
ent_ctr = 0

fq.each do |entry|
    ent_ctr += 1
    if ent_ctr > 1000
        file_ctr += 1
        fqeq.close
        fqeq = File.new("/Users/cjose/blat/fq#{file_ctr}_out.fa", 'w')
        ent_ctr = 0    
    end
    d = "#{entry.definition}"
    seq = entry.naseq.to_fasta(d)
    fqeq.puts "#{seq}"
end
fqeq.close

################################# TEST ########################################


# /dev/null contains server output

puts Time.now
system "./gfServer start localhost 9500 chr1.nib &> /dev/null &"
puts "Starting BLAT..."

while true
	sleep(3)	
	puts "Starting client..."
	result = system "./gfClient localhost 9500 . /Users/cjose/blat/test_q.fa /Users/cjose/blat/test.psl "
	break if result	
end
	
puts "Waiting for 2nd client..."
0.upto file_ctr do |file_index|

sleep(3)
	output = system "./gfClient localhost 9500 . /Users/cjose/blat/fq#{file_index}_out.fa /Users/cjose/blat/out#{file_index}.psl &"
	puts "Starting 2nd client..."
		if !output == false then 
			puts Time.now
			break if !output
		end
end

	

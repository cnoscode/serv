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


0.upto file_ctr do |file_index|
	output = system "./gfClient localhost 9500 . /Users/cjose/blat/fq#{file_index}_out.fa /Users/cjose/blat/out#{file_index}.psl &"
		#if output then 
	
		while !output == true 
		timeCheck = File.new("/Users/cjose/blat/timeCheck.txt", 'w')
		timeCheck.puts Time.new
		end	
		break if !output
	end
	

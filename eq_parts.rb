require 'bio'

fq = Bio::FlatFile.open('ERR000001.fastq')

file_ctr = 0
fqeq = File.new("/home/cjose/blat/fq#{file_ctr}_out.fa", 'w')
ent_ctr = 0

fq.each do |entry|
    ent_ctr += 1
    if ent_ctr > 100000
        file_ctr += 1
        fqeq.close
        fqeq = File.new("/home/cjose/blat/fq#{file_ctr}_out.fa", 'w')
        ent_ctr = 0    
    end
    d = "#{entry.definition}"
    seq = entry.naseq.to_fasta(d)
    fqeq.puts "#{seq}"
end
fqeq.close

#test
puts "Pinging host..."
pinging = system "ping -c 10 localhost"

	while pinging
		system "./gfServer start localhost 9051 zfchr1.nib &> /dev/null &" 
		puts "server started"
		sleep(5)
		puts system "./gfClient localhost 9051 . /Users/cjose/blat/test_q.fa out.psl"
		break
	end

=begin
   def test1
        system("./gfServer start localhost 9501 zfchr1.nib &> /dev/null &")
        system("./gfServer start localhost 9502 zfchr1.nib &> /dev/null &")

        puts system("./gfClient localhost 9501 . /home/cjose/blat/fq8_out.fa /home/cjose/blat/output1.psl")
        puts system("./gfClient localhost 9502 . /home/cjose/blat/ee_query.fa /home/cjose/blat/output2.psl")
   end
         test1
=end

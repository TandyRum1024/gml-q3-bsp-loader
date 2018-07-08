///q3_load_visdata(Buffer, offset)
var FILE = argument0;
var OFF = argument1;

var NUMBYTES, numCLUSTERS, byteCLUSTER;
var VISDATA = 0, BITSETS;

buffer_seek(FILE, buffer_seek_start, OFF);
numCLUSTERS = q3_read_int(FILE);
byteCLUSTER = q3_read_int(FILE);

NUMBYTES = numCLUSTERS*byteCLUSTER;

//Cluster numbers
VISDATA[ 0] = numCLUSTERS;
//Bytes per clusters
VISDATA[ 1] = byteCLUSTER;

BITSETS = buffer_create(NUMBYTES, buffer_fast, 1);
buffer_seek(BITSETS, buffer_seek_start, 0);
for (var i=0;i<NUMBYTES;i++)
{
    buffer_write(BITSETS, buffer_u8, buffer_read(FILE, buffer_u8));
}

show_debug_message(string(numCLUSTERS)+" CLUSTERS, "+string(byteCLUSTER)+" BYTES PER CLUSTERS, "+string(NUMBYTES)+" BYTES TOTAL");

//Bitset
VISDATA[ 2] = BITSETS;

return VISDATA;

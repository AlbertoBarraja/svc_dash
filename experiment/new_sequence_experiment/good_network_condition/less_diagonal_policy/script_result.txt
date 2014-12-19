BEGIN{
    l0=0;
    l1=0;
    l2=0;
    rcount=1;
}
/\[/ {
    if(rcount%2==0) {
	split($1,arr2,":");
	curtime=arr2[1]*3600+arr2[2]*60+arr2[3];
	if(cl0>l0) {
	    print curtime" "cl0+0" 0";
	} else if(cl1>l1) {
	    print curtime" "cl1+0" 1";
	} else {
	    print curtime" "cl2+0" 2";};
	l0=cl0;
	l1=cl1;
	l2=cl2;
    } else {
	split($1,arr,",");
	cl0=substr(arr[1],2);
	cl1=arr[2];
	cl2=substr(arr[3],1,length(arr[3])-1);
    } 
    rcount++;
}

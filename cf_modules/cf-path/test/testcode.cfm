<cfscript> 
      array = [1]; 
      newArray = arraySlice(array,1,1);//returns 2,3,4 
      writeDump(var=newArray);
      
</cfscript>

<script>
array = [1,2,3,4,5,6,7,8];
newArray = array.slice(1,4); //returns 2,3,4
document.write(newArray);
document.write("<br />");
newArray = array.slice(3); //returns 4,5,6,7,8
document.write(newArray);
</script>
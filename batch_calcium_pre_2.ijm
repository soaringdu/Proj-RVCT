fa_path = getDirectory("Choose the Input Directory");
file_list=getFileList(fa_path);	
for (l = 0; l < file_list.length; l++){
		if (startsWith(file_list[l],"aligned")){
			open(fa_path+file_list[l]);
			rename("raw");
			run("Z Project...", "projection=[Average Intensity]");
			run("Enhance Contrast", "saturated=0.35");
			rename("zpro");
			name=substring(file_list[l], 0, lengthOf(file_list[l])-4);
			inter=Stack.getFrameInterval();
			roiManager ("Reset"); 
			waitForUser("circle the ROIs");
			roiManager("Save", fa_path+name+".zip");
			selectWindow("zpro");
			roiManager("Show All with labels");
			//run("Enhance Contrast", "saturated=0.35");
			saveAs("Tiff",fa_path+"AVG_"+name+".tif");
			run("Set Measurements...", "area mean redirect=None decimal=8");
			selectWindow("raw");
			//run("Set Measurements...", "area centroid center redirect=None decimal=8");
			roiManager("Show All");
			roiManager("Multi Measure");
			saveAs("Results", fa_path+name+"_"+inter+".csv");
			roiManager ("Reset"); 
			run("Clear Results");
			close("*");
		}
}
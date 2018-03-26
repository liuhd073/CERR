% this is a wrapper function to create a .nrrd file from CERR and call
% pyradiomics.
% Requires specifying path to Pyradiomics
%
% RKP, 03/22/2018

function teststruct = PyradWrapper(scanM, maskM)
    pyradiomicsPath = 'C:\Users\pandyar1\pyradiomics\examples';
    paramFilePath = strcat(fileparts(which('pyradParams.yaml')),'\pyradParams.yaml') ;
    pyModule = 'pyFeatureExtraction';
    P = py.sys.path;

    %import python module if not in system path
    if count(P,pyradiomicsPath) == 0
        insert(P,int32(0),pyradiomicsPath);
    end
    py.importlib.import_module(pyModule);


    maskM = uint16(maskM);
    %write NRRDs (flip along 3rd axis??)
    scanFilename = strcat(tempdir,'scan.nrrd');
    scanRes = nrrdWriter(scanFilename, flip(scanM,3), [10,10,10], [0,0,0], 'raw');
   
    maskFilename = strcat(tempdir, 'mask.nrrd');
    maskRes = nrrdWriter(maskFilename, flip(maskM, 3), [10,10,10], [0,0,0], 'raw');
  

    %this python module will use the path of the newly generated nrrd files 
    %pass path of mask and scan here
    pyradiomicsDict = py.pyFeatureExtraction.extract(scanFilename, maskFilename, paramFilePath);
    teststruct = struct(pyradiomicsDict);
    




package nilvera.xmlvalidatior.business.concretes;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.StringWriter;

import javax.xml.transform.Source;
import javax.xml.transform.stream.StreamSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.multipart.MultipartFile;

import net.sf.saxon.s9api.Processor;
import net.sf.saxon.s9api.Serializer;
import net.sf.saxon.s9api.XsltCompiler;
import net.sf.saxon.s9api.XsltExecutable;
import net.sf.saxon.s9api.XsltTransformer;

public class SCHValidatiorManager {
	
	private Processor saxonProc;
	private XsltCompiler xsltCompiler;
	private XsltExecutable xsltExecutable;
    private XsltTransformer xsltTransformer;
    
    @Autowired
    public SCHValidatiorManager() 
    {
    	try 
		{
//			FileInputStream schFile = new FileInputStream(new File("etc\\UBL-TR_Main_Schematron.xsl"));
			FileInputStream schFile = new FileInputStream(new File("E:\\UBL-TR_Main_Schematron.xsl"));
			Source xsltSource = new StreamSource(schFile);
			
			saxonProc = new Processor(false);
			
			xsltCompiler = saxonProc.newXsltCompiler();
			
			xsltExecutable = xsltCompiler.compile(xsltSource);
			xsltTransformer = xsltExecutable.load();
			
		}
		catch (Exception e) 
		{
			e.printStackTrace();
		}
    }
    
    public String SchValidatior(MultipartFile file) 
    {
    	try
		{
			File doc = new File("\\" + file.getOriginalFilename());
			doc.createNewFile();
			
			FileOutputStream outputStream = new FileOutputStream(doc);
			outputStream.write(file.getBytes());
			outputStream.close();
			
			FileInputStream xmlFile = new FileInputStream(new File("\\" + file.getOriginalFilename()));
			Source xmlSource = new StreamSource(xmlFile);

			StringWriter resultWriter = new StringWriter();
	        Serializer result = saxonProc.newSerializer(resultWriter);

	        xsltTransformer.setSource(xmlSource);
	        xsltTransformer.setDestination(result);
	        
	        xsltTransformer.transform();
	        
	        doc.delete();
            
	        String resultString = resultWriter.toString();
	        if (resultString.length() == 0)
	            return new String("");
	            
	        return new String(resultString);

		} 
		catch (Exception e)
		{
			e.printStackTrace();
		}
		
		return new String("Ops! Bad File, Please Select Another File.");
    }

}

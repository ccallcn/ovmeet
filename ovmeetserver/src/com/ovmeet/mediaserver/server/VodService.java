//Author:lihong QQ:1410919373
package com.ovmeet.mediaserver.server;

import org.red5.server.api.IConnection;
import org.red5.server.api.IScope;
import org.red5.server.api.Red5;
import org.red5.server.api.ScopeUtils;
import java.io.File;
import java.text.SimpleDateFormat;
import java.util.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class VodService
{

	protected static final Logger log = LoggerFactory.getLogger("com.ovmeet.mediaserver.server.VodService"); 
	protected static String applicationRoot=System.getProperty("red5.root")+"/webapps/vimeet";

	public VodService()
	{
	}

	private String getStreamDirectory(IScope iscope)
	{
		StringBuilder stringbuilder = new StringBuilder();
		for (IScope iscope1 = ScopeUtils.findApplication(iscope); iscope != null && iscope != iscope1; iscope = iscope.getParent())
			stringbuilder.insert(0, (new StringBuilder()).append(iscope.getName()).append("/"));
		return (new StringBuilder(applicationRoot)).append(File.separator).append("streams").append(File.separator).append(stringbuilder.toString()).toString();
	}

	private String formatDate(Date date)
	{
		String s = "yy-MM-dd H:mm:ss";
		Locale locale = new Locale("en", "US");
		SimpleDateFormat simpledateformat = new SimpleDateFormat(s, locale);
		return simpledateformat.format(date);
	}

	public boolean reName(String s, String s1)
	{
		IScope iscope = Red5.getConnectionLocal().getScope();
		try
		{
			File file = new File(getStreamDirectory(iscope));
			File file1 = new File(file, s);
			File file2 = new File(file, s1);
			if (file1.exists() && !file2.exists())
				file1.renameTo(file2);
		}
		catch (Exception exception)
		{
			log.error("", exception);
			return false;
		}
		return true;
	}

	public boolean delVod(String s)
	{
		IScope iscope = Red5.getConnectionLocal().getScope();
		try
		{
			File file = new File(getStreamDirectory(iscope));
			File file1 = new File(file, s);
			if (file1.exists())
				file1.delete();
		}
		catch (Exception exception)
		{
			log.error("", exception);
			return false;
		}
		return true;
	}

	public Object[] getListOfAvailableFLVs()
	{
		IScope iscope;
		LinkedList linkedlist;
		iscope = Red5.getConnectionLocal().getScope();
		linkedlist = new LinkedList();
		//File file = new File(getStreamDirectory(iscope));
		File file = new File(getStreamDirectory(iscope));
		//System.out.println("test111:"+getStreamDirectory(iscope));
		if (file != null)
		{
			//System.out.println("tes3333");
			File afile[] = file.listFiles();
			if (afile != null)
			{
				
				//System.out.println("tes444:"+ afile.length);
				for (int i = 0; i < afile.length; i++)
				{
					File file1 = afile[i];
					String s = file1.getName();
					System.out.println("testsss+"+s);
					if (s.indexOf(".flv", s.length() - 4) != -1)
					{
						Date date = new Date(file1.lastModified());
						String s1 = formatDate(date);
						String s2 = s.substring(0, s.lastIndexOf("."));
						HashMap hashmap = new HashMap();
						hashmap.put("flvName", s2);
						hashmap.put("lastModified", s1);
						hashmap.put("size", Long.valueOf(file1.length() / 1024L));
						linkedlist.add(hashmap);
					}
				}

			}
		}
		return linkedlist.toArray();
	}

}

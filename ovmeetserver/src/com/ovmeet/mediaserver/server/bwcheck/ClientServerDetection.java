//Author:lihong QQ:1410919373 
package com.ovmeet.mediaserver.server.bwcheck;

import org.red5.server.api.IConnection;
import org.red5.server.api.Red5;
import org.red5.server.api.service.IPendingServiceCall;
import org.red5.server.api.service.IPendingServiceCallback;
import org.red5.server.api.stream.IStreamCapableConnection;
import java.util.HashMap;
import java.util.Map;

public class ClientServerDetection
	implements IPendingServiceCallback
{

	public ClientServerDetection()
	{
	}

	public void resultReceived(IPendingServiceCall ipendingservicecall)
	{
	}

	private IStreamCapableConnection getStats()
	{
		IConnection conn = Red5.getConnectionLocal();
		if (conn instanceof IStreamCapableConnection)
			return (IStreamCapableConnection)conn;
		else
			return null;
	}

	public Map onClientBWCheck(Object params[])
	{
		IStreamCapableConnection stats = getStats();
		Map statsValues = new HashMap();
		Integer time = (Integer)(params.length <= 0 ? Integer.valueOf(0) : params[0]);
		statsValues.put("cOutBytes", Long.valueOf(stats.getReadBytes()));
		statsValues.put("cInBytes", Long.valueOf(stats.getWrittenBytes()));
		statsValues.put("time", time);
		return statsValues;
	}
}

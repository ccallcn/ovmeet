//Author:lihong QQ:1410919373 
package com.ovmeet.mediaserver.server.bwcheck;

import org.red5.server.api.Red5;
import java.util.Map;

// Referenced classes of package com.ovmeet.mediaserver.server.bwcheck:
//			ClientServerDetection, ServerClientDetection

public class BandwidthDetection
{

	public BandwidthDetection()
	{
	}

	public Map onClientBWCheck(Object params[])
	{
		ClientServerDetection clientServer = new ClientServerDetection();
		return clientServer.onClientBWCheck(params);
	}

	public void onServerClientBWCheck(Object params[])
	{
		org.red5.server.api.IConnection conn = Red5.getConnectionLocal();
		ServerClientDetection serverClient = new ServerClientDetection();
		serverClient.checkBandwidth(conn);
	}
}

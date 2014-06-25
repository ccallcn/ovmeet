 //Author:lihong QQ:1410919373
package com.ovmeet.mediaserver.server.bwcheck;

import org.red5.server.api.IConnection;

public interface IBandwidthDetection
{

	public abstract void checkBandwidth(IConnection iconnection);

	public abstract void calculateClientBw(IConnection iconnection);
}

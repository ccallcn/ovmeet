//Author:lihong QQ:1410919373
package com.ovmeet.mediaserver.server.bwcheck;

import org.red5.server.api.IConnection;
import org.red5.server.api.Red5;
import org.red5.server.api.service.*;
import org.red5.server.api.stream.IStreamCapableConnection;
import java.util.*;

// Referenced classes of package com.ovmeet.mediaserver.server.bwcheck:
//			IBandwidthDetection

public class ServerClientDetection
	implements IPendingServiceCallback, IBandwidthDetection
{

	IConnection client;
	double latency;
	double cumLatency;
	int count;
	int sent;
	double kbitDown;
	double kbitUp;
	double deltaDown;
	double deltaUp;
	double deltaTime;
	Long timePassed;
	List pakSent;
	List pakRecv;
	private Map beginningValues;
	private double payload[];
	private double payload_1[];
	private double payload_2[];

	public ServerClientDetection()
	{
		client = null;
		latency = 0.0D;
		cumLatency = 1.0D;
		count = 0;
		sent = 0;
		kbitDown = 0.0D;
		kbitUp = 0.0D;
		deltaDown = 0.0D;
		deltaUp = 0.0D;
		deltaTime = 0.0D;
		pakSent = new ArrayList();
		pakRecv = new ArrayList();
		payload = new double[1200];
		payload_1 = new double[12000];
		payload_2 = new double[12000];
	}

	public void checkBandwidth(IConnection p_client)
	{
		calculateClientBw(p_client);
	}

	public void calculateClientBw(IConnection p_client)
	{
		for (int i = 0; i < 1200; i++)
			payload[i] = Math.random();

		p_client.setAttribute("payload", payload);
		for (int i = 0; i < 12000; i++)
			payload_1[i] = Math.random();

		p_client.setAttribute("payload_1", payload_1);
		for (int i = 0; i < 12000; i++)
			payload_2[i] = Math.random();

		p_client.setAttribute("payload_2", payload_2);
		IStreamCapableConnection beginningStats = getStats();
		Long start = new Long(System.nanoTime() / 0xf4240L);
		client = p_client;
		beginningValues = new HashMap();
		beginningValues.put("b_down", Long.valueOf(beginningStats.getWrittenBytes()));
		beginningValues.put("time", start);
		pakSent.add(start);
		sent++;
		callBWCheck("");
	}

	public void resultReceived(IPendingServiceCall call)
	{
		Long now = new Long(System.nanoTime() / 0xf4240L);
		pakRecv.add(now);
		timePassed = Long.valueOf(now.longValue() - ((Long)beginningValues.get("time")).longValue());
		count++;
		if (count == 1)
		{
			latency = Math.min(timePassed.longValue(), 800L);
			latency = Math.max(latency, 10D);
			pakSent.add(now);
			sent++;
			callBWCheck(client.getAttribute("payload"));
		} else
		if (count > 1 && count < 3 && timePassed.longValue() < 1000L)
		{
			pakSent.add(now);
			sent++;
			cumLatency++;
			callBWCheck(client.getAttribute("payload_1"));
		} else
		if (count >= 3 && count < 6 && timePassed.longValue() < 1000L)
		{
			pakSent.add(now);
			sent++;
			cumLatency++;
			callBWCheck(client.getAttribute("payload_1"));
		} else
		if (count >= 6 && timePassed.longValue() < 1000L)
		{
			pakSent.add(now);
			sent++;
			cumLatency++;
			callBWCheck(client.getAttribute("payload_2"));
		} else
		if (sent == count)
		{
			if (latency >= 100D && ((Long)pakRecv.get(1)).longValue() - ((Long)pakRecv.get(0)).longValue() > 1000L)
				latency = 100D;
			client.removeAttribute("payload");
			client.removeAttribute("payload_1");
			client.removeAttribute("payload_2");
			IStreamCapableConnection endStats = getStats();
			deltaDown = ((endStats.getWrittenBytes() - ((Long)beginningValues.get("b_down")).longValue()) * 8L) / 1000L;
			deltaTime = ((double)(now.longValue() - ((Long)beginningValues.get("time")).longValue()) - latency * cumLatency) / 1000D;
			if (Math.round(deltaTime) <= 0L)
				deltaTime = ((double)(now.longValue() - ((Long)beginningValues.get("time")).longValue()) + latency) / 1000D;
			kbitDown = Math.round(deltaDown / deltaTime);
			if (kbitDown < 100D)
				kbitDown = 100D;
			callBWDone();
		}
	}

	private void callBWCheck(Object payload)
	{
		IConnection conn = Red5.getConnectionLocal();
		Map statsValues = new HashMap();
		statsValues.put("count", Integer.valueOf(count));
		statsValues.put("sent", Integer.valueOf(sent));
		statsValues.put("timePassed", timePassed);
		statsValues.put("latency", Double.valueOf(latency));
		statsValues.put("cumLatency", Double.valueOf(cumLatency));
		statsValues.put("payload", payload);
		if (conn instanceof IServiceCapableConnection)
			((IServiceCapableConnection)conn).invoke("onBWCheck", new Object[] {
				statsValues
			}, this);
	}

	private void callBWDone()
	{
		IConnection conn = Red5.getConnectionLocal();
		Map statsValues = new HashMap();
		statsValues.put("kbitDown", Double.valueOf(kbitDown));
		statsValues.put("deltaDown", Double.valueOf(deltaDown));
		statsValues.put("deltaTime", Double.valueOf(deltaTime));
		statsValues.put("latency", Double.valueOf(latency));
		if (conn instanceof IServiceCapableConnection)
			((IServiceCapableConnection)conn).invoke("onBWDone", new Object[] {
				statsValues
			});
	}

	private IStreamCapableConnection getStats()
	{
		IConnection conn = Red5.getConnectionLocal();
		if (conn instanceof IStreamCapableConnection)
			return (IStreamCapableConnection)conn;
		else
			return null;
	}

	public void onServerClientBWCheck()
	{
		IConnection conn = Red5.getConnectionLocal();
		calculateClientBw(conn);
	}
}

/**
 * Autogenerated by Frugal Compiler (1.0.6)
 * DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
 *  @generated
 */

package foo;

import com.workiva.frugal.protocol.*;
import com.workiva.frugal.provider.FScopeProvider;
import com.workiva.frugal.transport.FScopeTransport;
import com.workiva.frugal.transport.FSubscription;
import org.apache.thrift.TException;
import org.apache.thrift.TApplicationException;
import org.apache.thrift.transport.TTransportException;
import org.apache.thrift.protocol.*;

import javax.annotation.Generated;
import java.util.logging.Logger;




/**
 * And this is a scope docstring.
 */
@Generated(value = "Autogenerated by Frugal Compiler (1.0.6)", date = "2015-11-24")
public class FooSubscriber {

	private static final String DELIMITER = ".";
	private static Logger LOGGER = Logger.getLogger(FooSubscriber.class.getName());

	private final FScopeProvider provider;

	public FooSubscriber(FScopeProvider provider) {
		this.provider = provider;
	}

	public interface FooHandler {
		void onFoo(FContext ctx, Thing req);
	}

	/**
	 * This is an operation docstring.
	 */
	public FSubscription subscribeFoo(String baz, final FooHandler handler) throws TException {
		final String op = "Foo";
		String prefix = String.format("foo.bar.%s.qux.", baz);
		String topic = String.format("%sFoo%s%s", prefix, DELIMITER, op);
		final FScopeProvider.Client client = provider.build();
		FScopeTransport transport = client.getTransport();
		transport.subscribe(topic);

		final FSubscription sub = new FSubscription(topic, transport);
		new Thread(new Runnable() {
			public void run() {
				while (true) {
					try {
						FContext ctx = client.getProtocol().readRequestHeader();
						Thing received = recvFoo(op, client.getProtocol());
						handler.onFoo(ctx, received);
					} catch (TException e) {
						if (e instanceof TTransportException) {
							TTransportException transportException = (TTransportException) e;
							if (transportException.getType() == TTransportException.END_OF_FILE) {
								return;
							}
						}
						LOGGER.severe("Subscriber recvFoo error " + e.getMessage());
						sub.signal(e);
						sub.unsubscribe();
						return;
					}
				}
			}
		}, "subscription").start();

		return sub;
	}

	private Thing recvFoo(String op, FProtocol iprot) throws TException {
		TMessage msg = iprot.readMessageBegin();
		if (!msg.name.equals(op)) {
			TProtocolUtil.skip(iprot, TType.STRUCT);
			iprot.readMessageEnd();
			throw new TApplicationException(TApplicationException.UNKNOWN_METHOD);
		}
		Thing req = new Thing();
		req.read(iprot);
		iprot.readMessageEnd();
		return req;
	}

	public interface BarHandler {
		void onBar(FContext ctx, Stuff req);
	}



	public FSubscription subscribeBar(String baz, final BarHandler handler) throws TException {
		final String op = "Bar";
		String prefix = String.format("foo.bar.%s.qux.", baz);
		String topic = String.format("%sFoo%s%s", prefix, DELIMITER, op);
		final FScopeProvider.Client client = provider.build();
		FScopeTransport transport = client.getTransport();
		transport.subscribe(topic);

		final FSubscription sub = new FSubscription(topic, transport);
		new Thread(new Runnable() {
			public void run() {
				while (true) {
					try {
						FContext ctx = client.getProtocol().readRequestHeader();
						Stuff received = recvBar(op, client.getProtocol());
						handler.onBar(ctx, received);
					} catch (TException e) {
						if (e instanceof TTransportException) {
							TTransportException transportException = (TTransportException) e;
							if (transportException.getType() == TTransportException.END_OF_FILE) {
								return;
							}
						}
						LOGGER.severe("Subscriber recvBar error " + e.getMessage());
						sub.signal(e);
						sub.unsubscribe();
						return;
					}
				}
			}
		}, "subscription").start();

		return sub;
	}

	private Stuff recvBar(String op, FProtocol iprot) throws TException {
		TMessage msg = iprot.readMessageBegin();
		if (!msg.name.equals(op)) {
			TProtocolUtil.skip(iprot, TType.STRUCT);
			iprot.readMessageEnd();
			throw new TApplicationException(TApplicationException.UNKNOWN_METHOD);
		}
		Stuff req = new Stuff();
		req.read(iprot);
		iprot.readMessageEnd();
		return req;
	}


}

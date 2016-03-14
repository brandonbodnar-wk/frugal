// Autogenerated by Frugal Compiler (1.0.6)
// DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING

package base

import (
	"bytes"
	"fmt"
	"log"
	"sync"
	"time"

	"git.apache.org/thrift.git/lib/go/thrift"
	"github.com/Workiva/frugal/lib/go"
)

// (needed to ensure safety because of naive import list construction.)
var _ = thrift.ZERO
var _ = fmt.Printf
var _ = bytes.Equal

type FBaseFoo interface {
	BasePing(ctx *frugal.FContext) (err error)
}

type FBaseFooClient struct {
	transport       frugal.FTransport
	protocolFactory *frugal.FProtocolFactory
	oprot           *frugal.FProtocol
	mu              sync.Mutex
}

func NewFBaseFooClient(t frugal.FTransport, p *frugal.FProtocolFactory) *FBaseFooClient {
	t.SetRegistry(frugal.NewFClientRegistry())
	return &FBaseFooClient{
		transport:       t,
		protocolFactory: p,
		oprot:           p.GetProtocol(t),
	}
}

func (f *FBaseFooClient) BasePing(ctx *frugal.FContext) (err error) {
	errorC := make(chan error, 1)
	resultC := make(chan struct{}, 1)
	if err = f.transport.Register(ctx, f.recvBasePingHandler(ctx, resultC, errorC)); err != nil {
		return
	}
	defer f.transport.Unregister(ctx)
	f.mu.Lock()
	if err = f.oprot.WriteRequestHeader(ctx); err != nil {
		f.mu.Unlock()
		return
	}
	if err = f.oprot.WriteMessageBegin("basePing", thrift.CALL, 0); err != nil {
		f.mu.Unlock()
		return
	}
	args := BaseFooBasePingArgs{}
	if err = args.Write(f.oprot); err != nil {
		f.mu.Unlock()
		return
	}
	if err = f.oprot.WriteMessageEnd(); err != nil {
		f.mu.Unlock()
		return
	}
	if err = f.oprot.Flush(); err != nil {
		f.mu.Unlock()
		return
	}
	f.mu.Unlock()

	select {
	case err = <-errorC:
	case <-resultC:
	case <-time.After(ctx.Timeout()):
		err = frugal.ErrTimeout
	case <-f.transport.Closed():
		err = frugal.ErrTransportClosed
	}
	return
}

func (f *FBaseFooClient) recvBasePingHandler(ctx *frugal.FContext, resultC chan<- struct{}, errorC chan<- error) frugal.FAsyncCallback {
	return func(tr thrift.TTransport) error {
		iprot := f.protocolFactory.GetProtocol(tr)
		if err := iprot.ReadResponseHeader(ctx); err != nil {
			errorC <- err
			return err
		}
		method, mTypeId, _, err := iprot.ReadMessageBegin()
		if err != nil {
			errorC <- err
			return err
		}
		if method != "basePing" {
			err = thrift.NewTApplicationException(thrift.WRONG_METHOD_NAME, "basePing failed: wrong method name")
			errorC <- err
			return err
		}
		if mTypeId == thrift.EXCEPTION {
			error0 := thrift.NewTApplicationException(thrift.UNKNOWN_APPLICATION_EXCEPTION, "Unknown Exception")
			var error1 thrift.TApplicationException
			error1, err = error0.Read(iprot)
			if err != nil {
				errorC <- err
				return err
			}
			if err = iprot.ReadMessageEnd(); err != nil {
				errorC <- err
				return err
			}
			if error1.TypeId() == frugal.RESPONSE_TOO_LARGE {
				err = thrift.NewTTransportException(frugal.RESPONSE_TOO_LARGE, "response too large for transport")
				errorC <- err
				return nil
			}
			err = error1
			errorC <- err
			return err
		}
		if mTypeId != thrift.REPLY {
			err = thrift.NewTApplicationException(thrift.INVALID_MESSAGE_TYPE_EXCEPTION, "basePing failed: invalid message type")
			errorC <- err
			return err
		}
		result := BaseFooBasePingResult{}
		if err = result.Read(iprot); err != nil {
			errorC <- err
			return err
		}
		if err = iprot.ReadMessageEnd(); err != nil {
			errorC <- err
			return err
		}
		resultC <- struct{}{}
		return nil
	}
}

type FBaseFooProcessor struct {
	processorMap map[string]frugal.FProcessorFunction
	writeMu      *sync.Mutex
	handler      FBaseFoo
}

func NewFBaseFooProcessor(handler FBaseFoo) *FBaseFooProcessor {
	writeMu := &sync.Mutex{}
	p := &FBaseFooProcessor{
		processorMap: make(map[string]frugal.FProcessorFunction),
		writeMu:      writeMu,
		handler:      handler,
	}
	p.AddToProcessorMap("basePing", &basefooFBasePing{handler: handler, writeMu: p.GetWriteMutex()})
	return p
}

func (p *FBaseFooProcessor) AddToProcessorMap(key string, proc frugal.FProcessorFunction) {
	p.processorMap[key] = proc
}

func (p *FBaseFooProcessor) GetProcessorFunction(key string) (processor frugal.FProcessorFunction, ok bool) {
	processor, ok = p.processorMap[key]
	return
}

func (p *FBaseFooProcessor) GetWriteMutex() *sync.Mutex {
	return p.writeMu
}

func (p *FBaseFooProcessor) Process(iprot, oprot *frugal.FProtocol) error {
	ctx, err := iprot.ReadRequestHeader()
	if err != nil {
		return err
	}
	name, _, _, err := iprot.ReadMessageBegin()
	if err != nil {
		return err
	}
	if processor, ok := p.GetProcessorFunction(name); ok {
		err := processor.Process(ctx, iprot, oprot)
		if err != nil {
			log.Printf("frugal: Error processing request with correlationID %s: %s\n", ctx.CorrelationID(), err.Error())
		}
		return err
	}
	iprot.Skip(thrift.STRUCT)
	iprot.ReadMessageEnd()
	x3 := thrift.NewTApplicationException(thrift.UNKNOWN_METHOD, "Unknown function "+name)
	p.writeMu.Lock()
	oprot.WriteResponseHeader(ctx)
	oprot.WriteMessageBegin(name, thrift.EXCEPTION, 0)
	x3.Write(oprot)
	oprot.WriteMessageEnd()
	oprot.Flush()
	p.writeMu.Unlock()
	return x3
}

type basefooFBasePing struct {
	handler FBaseFoo
	writeMu *sync.Mutex
}

func (p *basefooFBasePing) Process(ctx *frugal.FContext, iprot, oprot *frugal.FProtocol) error {
	args := BaseFooBasePingArgs{}
	var err error
	if err = args.Read(iprot); err != nil {
		iprot.ReadMessageEnd()
		p.writeMu.Lock()
		basefooWriteApplicationError(ctx, oprot, thrift.PROTOCOL_ERROR, "basePing", err.Error())
		p.writeMu.Unlock()
		return err
	}

	iprot.ReadMessageEnd()
	result := BaseFooBasePingResult{}
	var err2 error
	if err2 = p.handler.BasePing(ctx); err2 != nil {
		p.writeMu.Lock()
		basefooWriteApplicationError(ctx, oprot, thrift.INTERNAL_ERROR, "basePing", "Internal error processing basePing: "+err2.Error())
		p.writeMu.Unlock()
		return err2
	}
	p.writeMu.Lock()
	defer p.writeMu.Unlock()
	if err2 = oprot.WriteResponseHeader(ctx); err2 != nil {
		if err2 == frugal.ErrTooLarge {
			basefooWriteApplicationError(ctx, oprot, frugal.RESPONSE_TOO_LARGE, "basePing", "response too large: "+err2.Error())
			return nil
		}
		err = err2
	}
	if err2 = oprot.WriteMessageBegin("basePing", thrift.REPLY, 0); err2 != nil {
		if err2 == frugal.ErrTooLarge {
			basefooWriteApplicationError(ctx, oprot, frugal.RESPONSE_TOO_LARGE, "basePing", "response too large: "+err2.Error())
			return nil
		}
		err = err2
	}
	if err2 = result.Write(oprot); err == nil && err2 != nil {
		if err2 == frugal.ErrTooLarge {
			basefooWriteApplicationError(ctx, oprot, frugal.RESPONSE_TOO_LARGE, "basePing", "response too large: "+err2.Error())
			return nil
		}
		err = err2
	}
	if err2 = oprot.WriteMessageEnd(); err == nil && err2 != nil {
		if err2 == frugal.ErrTooLarge {
			basefooWriteApplicationError(ctx, oprot, frugal.RESPONSE_TOO_LARGE, "basePing", "response too large: "+err2.Error())
			return nil
		}
		err = err2
	}
	if err2 = oprot.Flush(); err == nil && err2 != nil {
		if err2 == frugal.ErrTooLarge {
			basefooWriteApplicationError(ctx, oprot, frugal.RESPONSE_TOO_LARGE, "basePing", "response too large: "+err2.Error())
			return nil
		}
		err = err2
	}
	return err
}

func basefooWriteApplicationError(ctx *frugal.FContext, oprot *frugal.FProtocol, type_ int32, method, message string) {
	x := thrift.NewTApplicationException(type_, message)
	oprot.WriteResponseHeader(ctx)
	oprot.WriteMessageBegin(method, thrift.EXCEPTION, 0)
	x.Write(oprot)
	oprot.WriteMessageEnd()
	oprot.Flush()
}

/*
*	Copyright (c) 2011, Conceptual Ideas
*   All rights reserved
*
*	Licensed under the Apache License, Version 2.0 (the "License");
*	you may not use this file except in compliance with the License.
*	You may obtain a copy of the License at
*
*	http://www.apache.org/licenses/LICENSE-2.0
*
*	Unless required by applicable law or agreed to in writing, software
*	distributed under the License is distributed on an "AS IS" BASIS,
*	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
*	See the License for the specific language governing permissions and
*	limitations under the License.
*/
package com.google.plus.endpoint
{
	import com.adobe.serialization.json.JSON;
	import com.google.plus.GooglePlusService;
	import com.google.plus.JsonMapper;
	import com.google.plus.endpoint.EndpointResponder;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;

	public class EndpointRequest
	{
		private var _query:Object={};
		private var _responders:Vector.<EndpointResponder>
		private var url:String
		private var mapper:JsonMapper
		private var service:GooglePlusService
		private var accessToken:String
		private var apiKey:String

		public function EndpointRequest(url:String, service:GooglePlusService)
		{

			this.url=service.endpoint + url;

			this.mapper=service.mapper;
			this.accessToken=service.accessToken;
			this.apiKey=service.apiKey;
		}

		public function set query(value:Object):void
		{
			_query=value || {};
		}

		public function execute():EndpointRequest
		{
			var loader:URLLoader=new URLLoader();
			var request:URLRequest=new URLRequest(url);
			var params:URLVariables=new URLVariables();

			if (accessToken)
				_query.access_token=accessToken;
			if (apiKey)
				_query.key=apiKey;
			_query.prettyPrint=true;
			for (var i:String in _query)
			{
				params[i]=_query[i];
			}
			request.data=params;

			loader.addEventListener(Event.COMPLETE, completeHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
			loader.load(request);
			return this;

		}

		private function errorHandler(event:Event):void
		{
			var responder:EndpointResponder
			for each (responder in _responders)
			{
				if (responder.fault != null)
					responder.fault(event);
			}

		}

		private var _raw:String

		public function get raw():String
		{
			return _raw;
		}

		private function completeHandler(event:Event):void
		{
			_raw=event.target.data;


			var json:Object=JSON.decode(_raw);

			var value:Object=mapper.map(json);
			var responder:EndpointResponder
			for each (responder in _responders)
			{

				responder.result(value);
			}
		


		}
		

		public function addResponder(responder:EndpointResponder):EndpointRequest
		{
			if (!_responders)
				_responders=new Vector.<EndpointResponder>();
			_responders.push(responder);
			return this;
		}
	}
}

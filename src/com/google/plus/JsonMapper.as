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
package com.google.plus
{

	import com.adobe.utils.DateUtil;
	import com.google.plus.models.Image;

	import flash.system.System;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;


	public class JsonMapper
	{

		private var _mappings:Dictionary=new Dictionary();


		public function JsonMapper()
		{

		}

		public function addMapping(kind:String, klazz:Class):void
		{
			// TODO : support avmplus.DescribeType.describeTypeJson
			var info:XML=describeType(klazz);
			_mappings[kind]=new Mapping(klazz, info..variable);

			try
			{
				System.disposeXML(info);
			}
			catch (e:Error)
			{

			}




		}

		public function getClassObject(kind:String):Object
		{
			var map:Mapping=_mappings[kind];
			return map ? new map.klazz() : {};
		}

		private function getClassName(value:Object, prop:String):String
		{
			var kind:String=String(value);
			var map:Mapping=_mappings[kind];
			if (!map)
			{
				addMapping(kind, value.constructor);
				map=_mappings[kind];
			}
			return map.descriptor[prop];

		}
		private static const VECTOR_NAME:String="__AS3__.vec::Vector.<";

		public function map(json:Object, kindObject:Object=null):Object
		{

			var kind:String=json.kind;
			if (!kind && kindObject is String)
				kind=String(kindObject);

			var prop:String

			var mapping:Mapping=_mappings[kind];

			var rtn:Object=kindObject && !(kindObject is String) ? kindObject : getClassObject(kind);

			var type:String
			var value:Object
			var isVector:Boolean
			var childKind:*

			var childKindClass:Class
			var vectorClass:String
			var isObject:Object
			for (prop in json)
			{
				if (prop == "kind")
					continue;
				if (!rtn.hasOwnProperty(prop))
					continue;

				if (mapping)
				{
					type=mapping.descriptor[prop]
				}
				else
				{

					type=getClassName(rtn, prop);

				}

				type=type || "";
				isVector=type.indexOf(VECTOR_NAME) != -1;



				if (type.indexOf(".") != -1)
				{
					if (isVector)
					{
						vectorClass=type;
						type=type.substring(VECTOR_NAME.length, type.length - 1);
					}

					childKindClass=getDefinitionByName(type) as Class;

					if (isVector && childKindClass)
					{
						var collection:Array=json[prop];
						for each (var entry:Object in collection)
						{
							value=map(entry, new childKindClass());
							if (rtn[prop] == null)
							{
								rtn[prop]=new (getDefinitionByName(vectorClass) as Class)();
							}
							rtn[prop].push(value)
						}
						continue;
					}

					if (childKindClass)
					{
						childKind=new childKindClass();
					}
					else
					{
						childKind=prop;
					}


					value=map(json[prop], childKind);

				}
				else
				{

					value=json[prop];
					if (type == "Date")
					{

						value=DateUtil.parseW3CDTF(String(value))
					}
				}


				rtn[prop]=value;






			}
			return rtn;

		}
	}
}

internal class Mapping
{
	public var descriptor:Object={};

	public var klazz:Class

	

	function Mapping(klazz:Class, d:XMLList):void
	{
		this.klazz=klazz;
		var variable:XML
		for each (variable in d)
		{
			descriptor[String(variable.@name)]=String(variable.@type);

		}
		
	}
}

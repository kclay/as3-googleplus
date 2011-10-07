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
	import com.google.plus.endpoint.Endpoint;
	import com.google.plus.models.Acl;
	import com.google.plus.models.Activity;
	import com.google.plus.models.ActivityFeed;
	import com.google.plus.models.Comment;
	import com.google.plus.models.CommentFeed;
	import com.google.plus.models.Email;
	import com.google.plus.models.Image;
	import com.google.plus.models.Organization;
	import com.google.plus.models.PeopleFeed;
	import com.google.plus.models.Person;
	import com.google.plus.models.Places;
	import com.google.plus.models.URL;

	public class GooglePlusService
	{
		private static const SERVER:String="https://www.googleapis.com/plus/";
		private static const jsonMapper:JsonMapper=new JsonMapper();
		init();

		private static function init():void
		{

			jsonMapper.addMapping("plus#person", Person);
			jsonMapper.addMapping("plus#acl", Acl);
			jsonMapper.addMapping("plus#activityFeed", ActivityFeed);
			jsonMapper.addMapping("plus#activity", Activity);
			jsonMapper.addMapping("plus#peopleFeed", PeopleFeed);
			jsonMapper.addMapping("plus#commentFeed", CommentFeed);
			jsonMapper.addMapping("plus#comment", Comment);
		/*jsonMapper.addMapping("person.urls",URL);
			jsonMapper.addMapping("person.image",Image);
			jsonMapper.addMapping("person.emails", Email);
			jsonMapper.addMapping("person.organization",Organization);
			jsonMapper.addMapping("person.placesLived",Places);*/

		}

		public function GooglePlusService(apiKey:String=null, version:String="v1")
		{
			_apiKey=apiKey;
			_apiVersion=version;
		}

		private var _accessToken:String

		private var _apiKey:String

		private var _apiVersion:String="v1";

		public function get accessToken():String
		{
			return _accessToken;
		}

		public function set accessToken(value:String):void
		{
			_accessToken=value;
		}

		public function get apiKey():String
		{
			return _apiKey;
		}

		public function set apiKey(value:String):void
		{
			_apiKey=value;
		}

		public function get apiVersion():String
		{
			return _apiVersion;
		}

		public function set apiVersion(value:String):void
		{
			_apiVersion=value;
		}

		public function get endpoint():String
		{
			return SERVER + _apiVersion;
		}

		public function get mapper():JsonMapper
		{
			return jsonMapper;
		}

	}
}

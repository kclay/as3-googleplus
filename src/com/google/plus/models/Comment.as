package com.google.plus.models
{

	public class Comment
	{
		public var id:String
		public var published:Date
		public var updated:Date
		public var actor:Actor
		public var verb:String
		public var object:PlusObject
		public var selfLink:String
		public var inReplyTo:Vector.<URLContent>

		public function Comment()
		{
		}
	}
}

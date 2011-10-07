package com.google.plus.models
{
	public class CommentFeed
	{
		public var nextPageToken:String
		public var nextLink:String
		public var title:String
		public var updated:Date
		public var id:String
		public var items:Vector.<Comment>
		public function CommentFeed()
		{
		}
	}
}
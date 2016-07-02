--Begin msg_checks.lua
--Begin pre_process function
local function pre_process(msg)
-- Begin 'RondoMsgChecks' text checks by @rondoozle
if is_chat_msg(msg) or is_super_group(msg) then
	if msg and not is_momod(msg) and not is_whitelisted(msg.from.id) then --if regular user
	local data = load_data(_config.moderation.data)
	local print_name = user_print_name(msg.from):gsub("‮", "") -- get rid of rtl in names
	local name_log = print_name:gsub("_", " ") -- name for log
	local to_chat = msg.to.type == 'chat'
	if data[tostring(msg.to.id)] and data[tostring(msg.to.id)]['settings'] then
		settings = data[tostring(msg.to.id)]['settings']
	else
		return
	end
	if settings.lock_arabic then
		lock_arabic = settings.lock_arabic
	else
        lock_arabic = '❌'
	end
	if settings.lock_rtl then
		lock_rtl = settings.lock_rtl
	else
        lock_rtl = '❌'
	end
		if settings.lock_tgservice then
		lock_tgservice = settings.lock_tgservice
	else
        lock_tgservice = '❌'
	end
	if settings.lock_link then
		lock_link = settings.lock_link
	else
        lock_link = '❌'
	end
	if settings.lock_member then
		lock_member = settings.lock_member
	else
        lock_member = '❌'
	end
	if settings.lock_spam then
		lock_spam = settings.lock_spam
	else
        lock_spam = '❌'
	end
	if settings.lock_sticker then
		lock_sticker = settings.lock_sticker
	else
        lock_sticker = '❌'
	end
	if settings.lock_contacts then
		lock_contacts = settings.lock_contacts
	else
        lock_contacts = '❌'
	end
	if settings.strict then
		strict = settings.strict
	else
        strict = '❌'
	end
	-------------------------
    if settings.lock_english then
        lock_en = settings.lock_english
    else
        lock_en = '❌'
end
   if settings.lock_tag then
           lock_tag = settings.lock_tag
   else 
           lock_tag = '❌'
end

 if settings.lock_username then
        lock_username = settings.lock_username
else 
        lock_username = '❌'
end

 if settings.lock_reply then
lock_reply = settings.lock_reply
else 
lock_reply = '❌'
end
 if settings.lock_fwd then
lock_fwd = settings.lock_fwd
else 
lock_fwd = '❌'
end

   if settings.lock_porn then
  lock_porn =settings.lock_porn
  else 
   lock_porn = '❌'
  end
  
		if msg and not msg.service and is_muted(msg.to.id, 'All: yes') or is_muted_user(msg.to.id, msg.from.id) and not msg.service then
			delete_msg(msg.id, ok_cb, false)
			if to_chat then
			--	kick_user(msg.from.id, msg.to.id)
			end
		end
		if msg.text then -- msg.text checks
			local _nl, ctrl_chars = string.gsub(msg.text, '%c', '')
			 local _nl, real_digits = string.gsub(msg.text, '%d', '')
			if lock_spam == "✅" and string.len(msg.text) > 2049 or ctrl_chars > 40 or real_digits > 2000 then
				delete_msg(msg.id, ok_cb, false)
				if strict == "yes" or to_chat then
					delete_msg(msg.id, ok_cb, false)
					kick_user(msg.from.id, msg.to.id)
				end
			end
			local is_link_msg = msg.text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or msg.text:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/")
			local is_bot = msg.text:match("?[Ss][Tt][Aa][Rr][Tt]=")
			if is_link_msg and lock_link == "✅" and not is_bot then
			 local linkhash = 'linkuser:'..msg.to.id..':'..msg.from.id
        redis:incr(linkhash)
        local linkredis = redis:get(linkhash)
          if tonumber(linkredis) == 1 and not is_momod(msg) then
send_large_msg(get_receiver(msg), 'link Not Allowed Here!\n if repeat send,Next time Kicked') 
				delete_msg(msg.id, ok_cb, false)
				end
          if strict == "✅" or tonumber(linkredis) == 2 and not is_momod(msg) then
            kick_user(msg.from.id, msg.to.id)
send_large_msg(get_receiver(msg), '['..msg.from.id..'] Link post Not Allowed Here!\nStatus : User Kicked')
            local linkhash = 'linkuser:'..msg.to.id..':'..msg.from.id
            redis:set(linkhash, 0)-- Reset the Counter
	          end
      end

      ------------------ENGLISH---------------------
		local is_en_msg = msg.text:match("[abcdefghigklmnopqrstuvwxyz]") or msg.text:match("[ABCDEFGHIGKLMNOPQRSTUVWXYZ]") 
			if is_en_msg and lock_en == "✅" then
			 local english_hash = 'english_user:'..msg.to.id..':'..msg.from.id
        redis:incr(english_hash)
        local english_redis = redis:get(english_hash)
        if msg.from.username then 
            user = "@"..msg.from.username
        else 
            user = msg.from.id
            end
          if tonumber(english_redis) == 1 and not is_momod(msg) and not msg.service then
send_large_msg(get_receiver(msg), '['..user..'] English Talk Not Allowed Here!\nNumber of warnings 1/4 \n\n If repeated 4 times,Kicked From Group') 
				delete_msg(msg.id, ok_cb, false)
	   elseif tonumber(english_redis) == 2 and not is_momod(msg) and not msg.service then
send_large_msg(get_receiver(msg), '['..user..'] English Talk Not Allowed Here!\nNumber of warnings 2/4 \n\n If repeated 4 times,Kicked From Group') 
				delete_msg(msg.id, ok_cb, false)
		elseif tonumber(english_redis) == 3 and not is_momod(msg) and not msg.service then
send_large_msg(get_receiver(msg), '['..user..'] English Talk Not Allowed Here!\nNumber of warnings 3/4 \n\n If repeated 4 times,Kicked From Group') 
				delete_msg(msg.id, ok_cb, false)
				end
          if strict == "✅" or tonumber(english_redis) == 4 and not is_momod(msg)  and not msg.service then
            kick_user(msg.from.id, msg.to.id)
send_large_msg(get_receiver(msg), '['..user..']  English Not Allowed Here!\nNumber of warnings 4/4\n\nStatus :❌User Kicked❌')
            local english_hash = 'english_user:'..msg.to.id..':'..msg.from.id
            redis:set(english_hash, 0)-- Reset the Counter
	          end
          end
					local is_tag_msg = msg.text:match("#")
			if is_tag_msg and lock_tag == "✅" then
			 local tag_hash = 'tag_user:'..msg.to.id..':'..msg.from.id
        redis:incr(tag_hash)
        local tag_redis = redis:get(tag_hash)
        if msg.from.username then 
            user = "@"..msg.from.username
        else 
            user = msg.from.id
            end
          if tonumber(tag_redis) == 1 and not is_momod(msg) and not msg.service  then
send_large_msg(get_receiver(msg), '['..user..'] Tag Post Not Allowed Here!\nNumber of warnings 1/3 \n\n If repeated 3 times,Kicked From Group') 
				delete_msg(msg.id, ok_cb, false)
          elseif tonumber(tag_redis) == 2 and not is_momod(msg) and not msg.service then
send_large_msg(get_receiver(msg), '['..user..'] Tag Post Not Allowed Here!\nNumber of warnings 2/3 \n\n if repeat send ,Kicked From Group') 
				delete_msg(msg.id, ok_cb, false)
            end
        
  if strict == "✅" or tonumber(tag_redis) == 3 and not is_momod(msg)  and not msg.service then
            kick_user(msg.from.id, msg.to.id)
send_large_msg(get_receiver(msg), '['..user..']  Tag Post Allowed Here!\nNumber of warnings 3/3\n\nStatus :❌User Kicked ❌')
            local tag_hash = 'tag_user:'..msg.to.id..':'..msg.from.id
            redis:set(tag_hash, 0)-- Reset the Counter
	          end
          end
				local is_user_msg = msg.text:match("@")
			if is_user_msg and lock_username == "✅"  then
			 local username_hash = 'username::'..msg.to.id..':'..msg.from.id
        redis:incr(username_hash)
        local user_redis = redis:get(username_hash)
        if msg.from.username then 
            user = "@"..msg.from.username
        else 
            user = msg.from.id
            end
          if tonumber(user_redis) == 1 and not is_momod(msg) and not msg.service then
send_large_msg(get_receiver(msg), '['..user..'] username Post Not Allowed Here!\nNumber of warnings 1/3 \n\n If repeated 3 times,Kicked From Group') 
				delete_msg(msg.id, ok_cb, false)
				elseif tonumber(user_redis) == 2 and not is_momod(msg) and not msg.service then
send_large_msg(get_receiver(msg), '['..user..'] Username post Not Allowed Here!\n if repeat send,Next time Kicked') 
				delete_msg(msg.id, ok_cb, false)
				end
          if strict == "✅" or tonumber(user_redis) == 3 and not is_momod(msg)   and not msg.service then
            kick_user(msg.from.id, msg.to.id)
send_large_msg(get_receiver(msg), '['..user..'] Username post Not Allowed Here!\nStatus :❌User Kicked❌')
            local username_hash = 'username::'..msg.to.id..':'..msg.from.id
            redis:set(username_hash, 0)-- Reset the Counter
	          end
      end
			if msg.reply_id and lock_reply == "✅"  then
				delete_msg(msg.id, ok_cb, false)
				if strict == "✅" or to_chat then
					kick_user(msg.from.id, msg.to.id)
				end
			end
			if msg.fwd_from and lock_fwd == "✅"  then
			 local tag_hash = 'forward_lock:'..msg.to.id..':'..msg.from.id
        redis:incr(tag_hash)
        local fwd_redis = redis:get(tag_hash)
        if msg.from.username then 
            user = "@"..msg.from.username
        else 
            user = msg.from.id
            end
          if tonumber(fwd_redis) == 1 and not is_momod(msg) and not msg.service then
send_large_msg(get_receiver(msg), '['..user..'] Forward msg Not Allowed Here!\nNumber of warnings 1/3 \n\n If repeated 3 times,Kicked From Group') 
				delete_msg(msg.id, ok_cb, false)
				elseif tonumber(fwd_redis) == 2 and not is_momod(msg) and not msg.service then
send_large_msg(get_receiver(msg), '['..user..'] Forward msg Not Allowed Here!\n if repeat send,Next time Kicked') 
				delete_msg(msg.id, ok_cb, false)
				end
          if strict == "✅" or tonumber(fwd_redis) == 3 and not is_momod(msg)   and not msg.service then
            kick_user(msg.from.id, msg.to.id)
send_large_msg(get_receiver(msg), '['..user..'] Forward msg Not Allowed Here!\nStatus :❌User Kicked❌')
            local tag_hash = 'forward_lock:'..msg.to.id..':'..msg.from.id
            redis:set(tag_hash, 0)-- Reset the Counter
	          end
      end
		if msg.service then 
			if lock_tgservice == "✅" then
				delete_msg(msg.id, ok_cb, false)
				if to_chat then
					return
				end
			end
		end
			local is_squig_msg = msg.text:match("[\216-\219][\128-\191]")
			if is_squig_msg and lock_arabic == "✅" then
				delete_msg(msg.id, ok_cb, false)
				if strict == "✅" or to_chat then
					kick_user(msg.from.id, msg.to.id)
				end
			end
			local print_name = msg.from.print_name
			local is_rtl = print_name:match("‮") or msg.text:match("‮")
			if is_rtl and lock_rtl == "✅" then
				delete_msg(msg.id, ok_cb, false)
				if strict == "✅" or to_chat then
					kick_user(msg.from.id, msg.to.id)
				end
			end
			if is_muted(msg.to.id, "Text: yes") and msg.text and not msg.media and not msg.service then
				delete_msg(msg.id, ok_cb, false)
				if to_chat then
					kick_user(msg.from.id, msg.to.id)
				end
			end
		end
		if msg.media then -- msg.media checks
			if msg.media.title then
				local is_link_title = msg.media.title:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or msg.media.title:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/")
				if is_link_title and lock_link == "✅" then
			 local linkhash = 'linkuser:'..msg.to.id..':'..msg.from.id
        redis:incr(linkhash)
        local linkredis = redis:get(linkhash)
        if msg.from.username then 
            user = "@"..msg.from.username
        else 
            user = msg.from.id
            end
          if tonumber(linkredis) == 1 and not is_momod(msg) then
send_large_msg(get_receiver(msg), '['..user..'] Link Not Allowed Here!\n if repeat send,Next time Kicked') 
				delete_msg(msg.id, ok_cb, false)
				end
          if strict == "✅" or tonumber(linkredis) == 2 and not is_momod(msg) then
            kick_user(msg.from.id, msg.to.id)
send_large_msg(get_receiver(msg), '['..user..'] Link post Not Allowed Here!\nStatus : User Kicked')
            local linkhash = 'linkuser:'..msg.to.id..':'..msg.from.id
            redis:set(linkhash, 0)-- Reset the Counter
	          end
      end      

	     	local is_en_title = msg.media.title:match("[abcdefghigklmnopqrstuvwxyz]") or msg.media.title:match("[ABCDEFGHIGKLMNOPQRSTUVWXYZ]") 
				if is_en_title and lock_en == "✅" then
			 local english_hash = 'english_user:'..msg.to.id..':'..msg.from.id
        redis:incr(english_hash)
        local english_redis = redis:get(english_hash)
        if msg.from.username then 
            user = "@"..msg.from.username
        else 
            user = msg.from.id
            end
          if tonumber(english_redis) == 1 and not is_momod(msg) and not msg.service then
send_large_msg(get_receiver(msg), '['..user..'] English Talk Not Allowed Here!\nNumber of warnings 1/4 \n\n If repeated 4 times,Kicked From Group') 
				delete_msg(msg.id, ok_cb, false)
	   elseif tonumber(english_redis) == 2 and not is_momod(msg) and not msg.service then
send_large_msg(get_receiver(msg), '['..user..'] English Talk Not Allowed Here!\nNumber of warnings 2/4 \n\n If repeated 4 times,Kicked From Group') 
				delete_msg(msg.id, ok_cb, false)
		elseif tonumber(english_redis) == 3 and not is_momod(msg) and not msg.service then
send_large_msg(get_receiver(msg), '['..user..'] English Talk Not Allowed Here!\nNumber of warnings 3/4 \n\n If repeated 4 times,Kicked From Group') 
				delete_msg(msg.id, ok_cb, false)
				end
          if strict == "✅" or tonumber(english_redis) == 4 and not is_momod(msg)  and not msg.service then
            kick_user(msg.from.id, msg.to.id)
send_large_msg(get_receiver(msg), '['..user..']  English Not Allowed Here!\nNumber of warnings 4/4\n\nStatus :❌User Kicked❌')
            local english_hash = 'english_user:'..msg.to.id..':'..msg.from.id
            redis:set(english_hash, 0)-- Reset the Counter
	          end
          end
					local is_username_title = msg.media.title:match("@")
				if is_username_title and lock_username == "✅" then
			 local username_hash = 'username::'..msg.to.id..':'..msg.from.id
        redis:incr(username_hash)
        local user_redis = redis:get(username_hash)
        if msg.from.username then 
            user = "@"..msg.from.username
        else 
            user = msg.from.id
            end
          if tonumber(user_redis) == 1 and not is_momod(msg) and not msg.service then
send_large_msg(get_receiver(msg), '['..user..'] Username Post Not Allowed Here!\nNumber of warnings 1/3 \n\n If repeated 3 times,Kicked From Group') 
				delete_msg(msg.id, ok_cb, false)
				elseif tonumber(user_redis) == 2 and not is_momod(msg) and not msg.service then
send_large_msg(get_receiver(msg), '['..user..'] Username post Not Allowed Here!\n if repeat send,Next time Kicked') 
				delete_msg(msg.id, ok_cb, false)
				end
          if strict == "✅" or tonumber(user_redis) == 3 and not is_momod(msg)   and not msg.service then
            kick_user(msg.from.id, msg.to.id)
send_large_msg(get_receiver(msg), '['..user..'] Username post Not Allowed Here!\nStatus :❌User Kicked❌')
            local username_hash = 'username::'..msg.to.id..':'..msg.from.id
            redis:set(username_hash, 0)-- Reset the Counter
	          end
      end
						local is_tag_title = msg.media.title:match("#")
				if is_tag_title and lock_tag == "✅" then
			 local tag_hash = 'tag_user:'..msg.to.id..':'..msg.from.id
        redis:incr(tag_hash)
        local tag_redis = redis:get(tag_hash)
        if msg.from.username then 
            user = "@"..msg.from.username
        else 
            user = msg.from.id
            end
          if tonumber(tag_redis) == 1 and not is_momod(msg) and not msg.service  then
send_large_msg(get_receiver(msg), '['..user..'] Tag Post Not Allowed Here!\nNumber of warnings 1/3 \n\n If repeated 3 times,Kicked From Group') 
				delete_msg(msg.id, ok_cb, false)
          elseif tonumber(tag_redis) == 2 and not is_momod(msg) and not msg.service then
send_large_msg(get_receiver(msg), '['..user..'] Tag Post Not Allowed Here!\nNumber of warnings 2/3 \n\n if repeat send ,Kicked From Group') 
				delete_msg(msg.id, ok_cb, false)
            end
        
  if strict == "✅" or tonumber(tag_redis) == 3 and not is_momod(msg)  and not msg.service then
            kick_user(msg.from.id, msg.to.id)
send_large_msg(get_receiver(msg), '['..user..']  Tag Post Allowed Here!\nNumber of warnings 3/3\n\nStatus :❌User Kicked ❌')
            local tag_hash = 'tag_user:'..msg.to.id..':'..msg.from.id
            redis:set(tag_hash, 0)-- Reset the Counter
	          end
          end
				local is_squig_title = msg.media.title:match("[\216-\219][\128-\191]")
				if is_squig_title and lock_arabic == "✅" then
					delete_msg(msg.id, ok_cb, false)
					if strict == "✅" or to_chat then
						kick_user(msg.from.id, msg.to.id)
					end
				end
			end
			if msg.media.description then
				local is_link_desc = msg.media.description:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or msg.media.description:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/")
				if is_link_desc and lock_link == "✅" then
			 local linkhash = 'linkuser:'..msg.to.id..':'..msg.from.id
        redis:incr(linkhash)
        local linkredis = redis:get(linkhash)
        if msg.from.username then 
            user = "@"..msg.from.username
        else 
            user = msg.from.id
            end
          if tonumber(linkredis) == 1 and not is_momod(msg) then
send_large_msg(get_receiver(msg), '['..user..'] link Not Allowed Here!\n if repeat send,Next time Kicked') 
				delete_msg(msg.id, ok_cb, false)
				end
          if strict == "✅" or tonumber(linkredis) == 2 and not is_momod(msg) then
            kick_user(msg.from.id, msg.to.id)
send_large_msg(get_receiver(msg), '['..user..'] Link post Not Allowed Here!\nStatus : User Kicked')
            local linkhash = 'linkuser:'..msg.to.id..':'..msg.from.id
            redis:set(linkhash, 0)-- Reset the Counter
	          end
      end

	     	local is_en_desc = msg.media.description:match("[abcdefghigklmnopqrstuvwxyz]") or msg.media.description:match("[ABCDEFGHIGKLMNOPQRSTUVWXYZ]") 
				if is_en_desc and lock_en == "✅" then
			 local english_hash = 'english_user:'..msg.to.id..':'..msg.from.id
        redis:incr(english_hash)
        local english_redis = redis:get(english_hash)
        if msg.from.username then 
            user = "@"..msg.from.username
        else 
            user = msg.from.id
            end
          if tonumber(english_redis) == 1 and not is_momod(msg) and not msg.service then
send_large_msg(get_receiver(msg), '['..user..'] English Talk Not Allowed Here!\nNumber of warnings 1/4 \n\n If repeated 4 times,Kicked From Group') 
				delete_msg(msg.id, ok_cb, false)
	   elseif tonumber(english_redis) == 2 and not is_momod(msg) and not msg.service then
send_large_msg(get_receiver(msg), '['..user..'] English Talk Not Allowed Here!\nNumber of warnings 2/4 \n\n If repeated 4 times,Kicked From Group') 
				delete_msg(msg.id, ok_cb, false)
		elseif tonumber(english_redis) == 3 and not is_momod(msg) and not msg.service then
send_large_msg(get_receiver(msg), '['..user..'] English Talk Not Allowed Here!\nNumber of warnings 3/4 \n\n If repeated 4 times,Kicked From Group') 
				delete_msg(msg.id, ok_cb, false)
				end
          if strict == "✅" or tonumber(english_redis) == 4 and not is_momod(msg)  and not msg.service then
            kick_user(msg.from.id, msg.to.id)
send_large_msg(get_receiver(msg), '['..user..']  English Talk Not Allowed Here!\nNumber of warnings 4/4\n\nStatus :❌User Kicked❌')
            local english_hash = 'english_user:'..msg.to.id..':'..msg.from.id
            redis:set(english_hash, 0)-- Reset the Counter
	          end
          end
					local is_username_desc = msg.media.description:match("@[%a%d]")
				if is_username_desc and lock_username == "✅" then
			 local username_hash = 'username::'..msg.to.id..':'..msg.from.id
        redis:incr(username_hash)
        local user_redis = redis:get(username_hash)
        if msg.from.username then 
            user = "@"..msg.from.username
        else 
            user = msg.from.id
            end
          if tonumber(user_redis) == 1 and not is_momod(msg) and not msg.service then
send_large_msg(get_receiver(msg), '['..user..'] username Post Not Allowed Here!\nNumber of warnings 1/3 \n\n If repeated 3 times,Kicked From Group') 
				delete_msg(msg.id, ok_cb, false)
				elseif tonumber(user_redis) == 2 and not is_momod(msg) and not msg.service then
send_large_msg(get_receiver(msg), '['..user..'] Username post Not Allowed Here!\n if repeat send,Next time Kicked') 
				delete_msg(msg.id, ok_cb, false)
				end
          if strict == "✅" or tonumber(user_redis) == 3 and not is_momod(msg)   and not msg.service then
            kick_user(msg.from.id, msg.to.id)
send_large_msg(get_receiver(msg), '['..user..'] Username post Not Allowed Here!\nStatus :❌User Kicked❌')
            local username_hash = 'username::'..msg.to.id..':'..msg.from.id
            redis:set(username_hash, 0)-- Reset the Counter
	          end
      end
						local is_tag_desc = msg.media.description:match("#")
				if is_tag_desc and lock_tag == "✅" then
			 local tag_hash = 'tag_user:'..msg.to.id..':'..msg.from.id
        redis:incr(tag_hash)
        local tag_redis = redis:get(tag_hash)
        if msg.from.username then 
            user = "@"..msg.from.username
        else 
            user = msg.from.id
            end
          if tonumber(tag_redis) == 1 and not is_momod(msg) and not msg.service  then
send_large_msg(get_receiver(msg), '['..user..'] Tag Post Not Allowed Here!\nNumber of warnings 1/3 \n\n If repeated 3 times,Kicked From Group') 
				delete_msg(msg.id, ok_cb, false)
          elseif tonumber(tag_redis) == 2 and not is_momod(msg) and not msg.service then
send_large_msg(get_receiver(msg), '['..user..'] Tag Post Not Allowed Here!\nNumber of warnings 2/3 \n\n if repeat send ,Kicked From Group') 
				delete_msg(msg.id, ok_cb, false)
            end
        
  if strict == "✅" or tonumber(tag_redis) == 3 and not is_momod(msg)  and not msg.service then
            kick_user(msg.from.id, msg.to.id)
send_large_msg(get_receiver(msg), '['..user..']  Tag Post Allowed Here!\nNumber of warnings 3/3\n\nStatus :❌User Kicked ❌')
            local tag_hash = 'tag_user:'..msg.to.id..':'..msg.from.id
            redis:set(tag_hash, 0)-- Reset the Counter
	          end
          end
				local is_squig_desc = msg.media.description:match("[\216-\219][\128-\191]")
				if is_squig_desc and lock_arabic == "✅" then
					delete_msg(msg.id, ok_cb, false)
					if strict == "✅" or to_chat then
						kick_user(msg.from.id, msg.to.id)
					end
				end
			end
			if msg.media.caption then -- msg.media.caption checks
				local is_link_caption = msg.media.caption:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or msg.media.caption:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/")
				if is_link_caption and lock_link == "✅" then
			 local linkhash = 'linkuser:'..msg.to.id..':'..msg.from.id
        redis:incr(linkhash)
        local linkredis = redis:get(linkhash)
        if msg.from.username then 
            user = "@"..msg.from.username
        else 
            user = msg.from.id
            end
          if tonumber(linkredis) == 1 and not is_momod(msg) then
send_large_msg(get_receiver(msg), '['..user..'] link Not Allowed Here!\n if repeat send,Next time Kicked') 
				delete_msg(msg.id, ok_cb, false)
				end
          if strict == "✅" or tonumber(linkredis) == 2 and not is_momod(msg) then
            kick_user(msg.from.id, msg.to.id)
send_large_msg(get_receiver(msg), '['..user..'] Link post Not Allowed Here!\nStatus : User Kicked')
            local linkhash = 'linkuser:'..msg.to.id..':'..msg.from.id
            redis:set(linkhash, 0)-- Reset the Counter
	          end
      end

	     	local is_en_caption = msg.media.caption:match("[abcdefghigklmnopqrstuvwxyz]") or msg.media.caption:match("[ABCDEFGHIGKLMNOPQRSTUVWXYZ]") 
				if is_en_caption and lock_en == "✅" then
			 local english_hash = 'english_user:'..msg.to.id..':'..msg.from.id
        redis:incr(english_hash)
        local english_redis = redis:get(english_hash)
        if msg.from.username then 
            user = "@"..msg.from.username
        else 
            user = msg.from.id
            end
          if tonumber(english_redis) == 1 and not is_momod(msg) and not msg.service then
send_large_msg(get_receiver(msg), '['..user..'] English Talk Not Allowed Here!\nNumber of warnings 1/4 \n\n If repeated 4 times,Kicked From Group') 
				delete_msg(msg.id, ok_cb, false)
	   elseif tonumber(english_redis) == 2 and not is_momod(msg) and not msg.service then
send_large_msg(get_receiver(msg), '['..user..'] English Talk Not Allowed Here!\nNumber of warnings 2/4 \n\n If repeated 4 times,Kicked From Group') 
				delete_msg(msg.id, ok_cb, false)
		elseif tonumber(english_redis) == 3 and not is_momod(msg) and not msg.service then
send_large_msg(get_receiver(msg), '['..user..'] English Talk Not Allowed Here!\nNumber of warnings 3/4 \n\n If repeated 4 times,Kicked From Group') 
				delete_msg(msg.id, ok_cb, false)
				end
          if strict == "✅" or tonumber(english_redis) == 4 and not is_momod(msg)  and not msg.service then
            kick_user(msg.from.id, msg.to.id)
send_large_msg(get_receiver(msg), '['..user..']  English Not Allowed Here!\nNumber of warnings 4/4\n\nStatus :❌User Kicked❌')
            local english_hash = 'english_user:'..msg.to.id..':'..msg.from.id
            redis:set(english_hash, 0)-- Reset the Counter
	          end
          end
					local is_username_caption = msg.media.caption:match("@[%a%d]")
				if is_username_caption and lock_username == "✅" then
			 local username_hash = 'username::'..msg.to.id..':'..msg.from.id
        redis:incr(username_hash)
        local user_redis = redis:get(username_hash)
        if msg.from.username then 
            user = "@"..msg.from.username
        else 
            user = msg.from.id
            end
          if tonumber(user_redis) == 1 and not is_momod(msg) and not msg.service then
send_large_msg(get_receiver(msg), '['..user..'] username Post Not Allowed Here!\nNumber of warnings 1/3 \n\n If repeated 3 times,Kicked From Group') 
				delete_msg(msg.id, ok_cb, false)
				elseif tonumber(user_redis) == 2 and not is_momod(msg) and not msg.service then
send_large_msg(get_receiver(msg), '['..user..'] Username post Not Allowed Here!\n if repeat send,Next time Kicked') 
				delete_msg(msg.id, ok_cb, false)
				end
          if strict == "✅" or tonumber(user_redis) == 3 and not is_momod(msg)   and not msg.service then
            kick_user(msg.from.id, msg.to.id)
send_large_msg(get_receiver(msg), '['..user..'] Username post Not Allowed Here!\nStatus :❌User Kicked❌')
            local username_hash = 'username::'..msg.to.id..':'..msg.from.id
            redis:set(username_hash, 0)-- Reset the Counter
	          end
      end
						local is_tag_caption = msg.media.caption:match("#")
				if is_tag_caption and lock_tag == "✅" then
			 local tag_hash = 'tag_user:'..msg.to.id..':'..msg.from.id
        redis:incr(tag_hash)
        local tag_redis = redis:get(tag_hash)
        if msg.from.username then 
            user = "@"..msg.from.username
        else 
            user = msg.from.id
            end
          if tonumber(tag_redis) == 1 and not is_momod(msg) and not msg.service  then
send_large_msg(get_receiver(msg), '['..user..'] Tag Post Not Allowed Here!\nNumber of warnings 1/3 \n\n If repeated 3 times,Kicked From Group') 
				delete_msg(msg.id, ok_cb, false)
          elseif tonumber(tag_redis) == 2 and not is_momod(msg) and not msg.service then
send_large_msg(get_receiver(msg), '['..user..'] Tag Post Not Allowed Here!\nNumber of warnings 2/3 \n\n if repeat send ,Kicked From Group') 
				delete_msg(msg.id, ok_cb, false)
            end
        
  if strict == "✅" or tonumber(tag_redis) == 3 and not is_momod(msg)  and not msg.service then
            kick_user(msg.from.id, msg.to.id)
send_large_msg(get_receiver(msg), '['..user..']  Tag Post Allowed Here!\nNumber of warnings 3/3\n\nStatus :❌User Kicked ❌')
            local tag_hash = 'tag_user:'..msg.to.id..':'..msg.from.id
            redis:set(tag_hash, 0)-- Reset the Counter
	          end
          end
				local is_squig_caption = msg.media.caption:match("[\216-\219][\128-\191]")
					if is_squig_caption and lock_arabic == "✅" then
						delete_msg(msg.id, ok_cb, false)
						if strict == "✅" or to_chat then
							kick_user(msg.from.id, msg.to.id)
						end
					end
				local is_username_caption = msg.media.caption:match("^@[%a%d]")
				if is_username_caption and lock_link == "✅" then
			 local username_hash = 'username::'..msg.to.id..':'..msg.from.id
        redis:incr(username_hash)
        local user_redis = redis:get(username_hash)
        if msg.from.username then 
            user = "@"..msg.from.username
        else 
            user = msg.from.id
            end
          if tonumber(user_redis) == 1 and not is_momod(msg) and not msg.service then
send_large_msg(get_receiver(msg), '['..user..'] username Post Not Allowed Here!\nNumber of warnings 1/3 \n\n If repeated 3 times,Kicked From Group') 
				delete_msg(msg.id, ok_cb, false)
				elseif tonumber(user_redis) == 2 and not is_momod(msg) and not msg.service then
send_large_msg(get_receiver(msg), '['..user..'] Username post Not Allowed Here!\n if repeat send,Next time Kicked') 
				delete_msg(msg.id, ok_cb, false)
				end
          if strict == "✅" or tonumber(user_redis) == 3 and not is_momod(msg)   and not msg.service then
            kick_user(msg.from.id, msg.to.id)
send_large_msg(get_receiver(msg), '['..user..'] Username post Not Allowed Here!\nStatus :❌User Kicked❌')
            local username_hash = 'username::'..msg.to.id..':'..msg.from.id
            redis:set(username_hash, 0)-- Reset the Counter
	          end
      end
				if lock_sticker == "✅" and msg.media.caption:match("sticker.webp") then
					delete_msg(msg.id, ok_cb, false)
					if strict == "✅" or to_chat then
						kick_user(msg.from.id, msg.to.id)
					end
				end
			end
			if msg.media.type:match("contact") and lock_contacts == "yes" then
				delete_msg(msg.id, ok_cb, false)
				if strict == "✅" or to_chat then
					kick_user(msg.from.id, msg.to.id)
				end
			end
			local is_photo_caption =  msg.media.caption and msg.media.caption:match("photo")--".jpg",
			if is_muted(msg.to.id, 'Photo: yes') and msg.media.type:match("photo") or is_photo_caption and not msg.service then
				delete_msg(msg.id, ok_cb, false)
				if strict == "✅" or to_chat then
					--	kick_user(msg.from.id, msg.to.id)
				end
			end
			local is_gif_caption =  msg.media.caption and msg.media.caption:match(".mp4")
			if is_muted(msg.to.id, 'Gifs: yes') and is_gif_caption and msg.media.type:match("document") and not msg.service then
				delete_msg(msg.id, ok_cb, false)
				if strict == "✅" or to_chat then
					--	kick_user(msg.from.id, msg.to.id)
				end
			end
			if is_muted(msg.to.id, 'Audio: yes') and msg.media.type:match("audio") and not msg.service then
				delete_msg(msg.id, ok_cb, false)
				if strict == "✅" or to_chat then
					kick_user(msg.from.id, msg.to.id)
				end
			end
			local is_video_caption = msg.media.caption and msg.media.caption:lower(".mp4","video")
			if  is_muted(msg.to.id, 'Video: yes') and msg.media.type:match("video") and not msg.service then
				delete_msg(msg.id, ok_cb, false)
				if strict == "yes" or to_chat then
					kick_user(msg.from.id, msg.to.id)
				end
			end
			if is_muted(msg.to.id, 'Documents: yes') and msg.media.type:match("document") and not msg.service then
				delete_msg(msg.id, ok_cb, false)
				if strict == "✅" or to_chat then
					kick_user(msg.from.id, msg.to.id)
				end
			end
		end
		if msg.fwd_from then
			if msg.fwd_from.title then
				local is_link_title = msg.fwd_from.title:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or msg.fwd_from.title:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/")
				if is_link_title and lock_link == "✅" then
			 local linkhash = 'linkuser:'..msg.to.id..':'..msg.from.id
        redis:incr(linkhash)
        local linkredis = redis:get(linkhash)
        if msg.from.username then 
            user = "@"..msg.from.username
        else 
            user = msg.from.id
            end
          if tonumber(linkredis) == 1 and not is_momod(msg) then
send_large_msg(get_receiver(msg), '['..user..'] link Not Allowed Here!\n if repeat send,Next time Kicked') 
				delete_msg(msg.id, ok_cb, false)
				end
          if strict == "✅" or tonumber(linkredis) == 2 and not is_momod(msg) then
            kick_user(msg.from.id, msg.to.id)
send_large_msg(get_receiver(msg), '['..user..'] Link post Not Allowed Here!\nStatus : User Kicked')
            local linkhash = 'linkuser:'..msg.to.id..':'..msg.from.id
            redis:set(linkhash, 0)-- Reset the Counter
	          end
      end

	     	local is_en_title = msg.fwd_from.title:match("[abcdefghigklmnopqrstuvwxyz]") or msg.fwd_from.title:match("[ABCDEFGHIGKLMNOPQRSTUVWXYZ]") 
				if is_en_title and lock_en == "✅" then
			 local english_hash = 'english_user:'..msg.to.id..':'..msg.from.id
        redis:incr(english_hash)
        local english_redis = redis:get(english_hash)
        if msg.from.username then 
            user = "@"..msg.from.username
        else 
            user = msg.from.id
            end
          if tonumber(english_redis) == 1 and not is_momod(msg) and not msg.service then
send_large_msg(get_receiver(msg), '['..user..'] English Talk Not Allowed Here!\nNumber of warnings 1/4 \n\n If repeated 4 times,Kicked From Group') 
				delete_msg(msg.id, ok_cb, false)
	   elseif tonumber(english_redis) == 2 and not is_momod(msg) and not msg.service then
send_large_msg(get_receiver(msg), '['..user..'] English Talk Not Allowed Here!\nNumber of warnings 2/4 \n\n If repeated 4 times,Kicked From Group') 
				delete_msg(msg.id, ok_cb, false)
		elseif tonumber(english_redis) == 3 and not is_momod(msg) and not msg.service then
send_large_msg(get_receiver(msg), '['..user..'] English Talk Not Allowed Here!\nNumber of warnings 3/4 \n\n If repeated 4 times,Kicked From Group') 
				delete_msg(msg.id, ok_cb, false)
				end
          if strict == "✅" or tonumber(english_redis) == 4 and not is_momod(msg)  and not msg.service then
            kick_user(msg.from.id, msg.to.id)
send_large_msg(get_receiver(msg), '['..user..']  English Not Allowed Here!\nNumber of warnings 4/4\n\nStatus :❌User Kicked❌')
            local english_hash = 'english_user:'..msg.to.id..':'..msg.from.id
            redis:set(english_hash, 0)-- Reset the Counter
	          end
          end
					local is_username_title = msg.fwd_from.title:match("@[%a%d]")
				if is_username_title and lock_username == "✅" then
			 local username_hash = 'username::'..msg.to.id..':'..msg.from.id
        redis:incr(username_hash)
        local user_redis = redis:get(username_hash)
        if msg.from.username then 
            user = "@"..msg.from.username
        else 
            user = msg.from.id
            end
          if tonumber(user_redis) == 1 and not is_momod(msg) and not msg.service then
send_large_msg(get_receiver(msg), '['..user..'] username Post Not Allowed Here!\nNumber of warnings 1/3 \n\n If repeated 3 times,Kicked From Group') 
				delete_msg(msg.id, ok_cb, false)
				elseif tonumber(user_redis) == 2 and not is_momod(msg) and not msg.service then
send_large_msg(get_receiver(msg), '['..user..'] Username post Not Allowed Here!\n if repeat send,Next time Kicked') 
				delete_msg(msg.id, ok_cb, false)
				end
          if strict == "✅" or tonumber(user_redis) == 3 and not is_momod(msg)   and not msg.service then
            kick_user(msg.from.id, msg.to.id)
send_large_msg(get_receiver(msg), '['..user..'] Username post Not Allowed Here!\nStatus :❌User Kicked❌')
            local username_hash = 'username::'..msg.to.id..':'..msg.from.id
            redis:set(username_hash, 0)-- Reset the Counter
	          end
      end
						local is_tag_title = msg.fwd_from.title:match("#")
				if is_tag_title and lock_tag == "✅" then
			 local tag_hash = 'tag_user:'..msg.to.id..':'..msg.from.id
        redis:incr(tag_hash)
        local tag_redis = redis:get(tag_hash)
        if msg.from.username then 
            user = "@"..msg.from.username
        else 
            user = msg.from.id
            end
          if tonumber(tag_redis) == 1 and not is_momod(msg) and not msg.service  then
send_large_msg(get_receiver(msg), '['..user..'] Tag Post Not Allowed Here!\nNumber of warnings 1/3 \n\n If repeated 3 times,Kicked From Group') 
				delete_msg(msg.id, ok_cb, false)
          elseif tonumber(tag_redis) == 2 and not is_momod(msg) and not msg.service then
send_large_msg(get_receiver(msg), '['..user..'] Tag Post Not Allowed Here!\nNumber of warnings 2/3 \n\n if repeat send ,Kicked From Group') 
				delete_msg(msg.id, ok_cb, false)
            end
        
  if strict == "✅" or tonumber(tag_redis) == 3 and not is_momod(msg)  and not msg.service then
            kick_user(msg.from.id, msg.to.id)
send_large_msg(get_receiver(msg), '['..user..']  Tag Post Allowed Here!\nNumber of warnings 3/3\n\nStatus :❌User Kicked ❌')
            local tag_hash = 'tag_user:'..msg.to.id..':'..msg.from.id
            redis:set(tag_hash, 0)-- Reset the Counter
	          end
          end
				local is_squig_title = msg.fwd_from.title:match("[\216-\219][\128-\191]")
				if is_squig_title and lock_arabic == "✅" then
					delete_msg(msg.id, ok_cb, false)
					if strict == "✅" or to_chat then
						kick_user(msg.from.id, msg.to.id)
					end
				end
			end
			if is_muted_user(msg.to.id, msg.fwd_from.peer_id) then
				delete_msg(msg.id, ok_cb, false)
			end
		end
		if msg.service then -- msg.service checks
		local action = msg.action.type
			if action == 'chat_add_user_link' then
				local user_id = msg.from.id
				local _nl, ctrl_chars = string.gsub(msg.text, '%c', '')
				if string.len(msg.from.print_name) > 70 or ctrl_chars > 40 and lock_group_spam == 'yes' then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] joined and Service Msg deleted (#spam name)")
					delete_msg(msg.id, ok_cb, false)
					if strict == "✅" or to_chat then
						savelog(msg.to.id, name_log.." ["..msg.from.id.."] joined and kicked (#spam name)")
						kick_user(msg.from.id, msg.to.id)
					end
				end
				local print_name = msg.from.print_name
				local is_rtl_name = print_name:match("‮")
				if is_rtl_name and lock_rtl == "✅" then
					savelog(msg.to.id, name_log.." User ["..msg.from.id.."] joined and kicked (#RTL char in name)")
					kick_user(user_id, msg.to.id)
				end
				if lock_member == '✅' then
					savelog(msg.to.id, name_log.." User ["..msg.from.id.."] joined and kicked (#lockmember)")
					kick_user(user_id, msg.to.id)
					delete_msg(msg.id, ok_cb, false)
				end
			end
			if action == 'chat_add_user' and not is_momod2(msg.from.id, msg.to.id) then
				local user_id = msg.action.user.id
				if string.len(msg.action.user.print_name) > 70 and lock_group_spam == 'yes' then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] added ["..user_id.."]: Service Msg deleted (#spam name)")
					delete_msg(msg.id, ok_cb, false)
					if strict == "✅" or to_chat then
						savelog(msg.to.id, name_log.." ["..msg.from.id.."] added ["..user_id.."]: added user kicked (#spam name) ")
						delete_msg(msg.id, ok_cb, false)
						kick_user(msg.from.id, msg.to.id)
					end
				end
				local print_name = msg.action.user.print_name
				local is_rtl_name = print_name:match("‮")
				if is_rtl_name and lock_rtl == "✅" then
					savelog(msg.to.id, name_log.." User ["..msg.from.id.."] added ["..user_id.."]: added user kicked (#RTL char in name)")
					kick_user(user_id, msg.to.id)
				end
				if msg.to.type == 'channel' and lock_member == '✅' then
					savelog(msg.to.id, name_log.." User ["..msg.from.id.."] added ["..user_id.."]: added user kicked  (#lockmember)")
					kick_user(user_id, msg.to.id)
					delete_msg(msg.id, ok_cb, false)
				end
			end
		end
	end
end
-- End 'RondoMsgChecks' text checks by @Rondoozle
	return msg
end
--End pre_process function
return {
	patterns = {},
	pre_process = pre_process
}
--End msg_checks.lua
--By @Rondoozle

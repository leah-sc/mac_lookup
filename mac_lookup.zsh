#!/usr/bin/env -S zsh -euf
# This is free and unencumbered software released into the public domain.
# For more information, please refer to <https://unlicense.org>
# SPDX-License-Identifier: Unlicense

# Set sane defaults
emulate -L zsh
# Set -eu if not running interactively
[[ -o interactive ]] || set -eu

: ${APPLE_SUPPORT_URL:="https://support-sp.apple.com/sp/product?cc="}
readonly APPLE_SUPPORT_URL

function get_xml_tag tag
# Return the contents of an XML tag
# :param tag: the tag to search for
#
# :returns: contents of $tag if found, else empty string
{
	local tag="${1:?}"
	
	# Get input from STDIN
	while	read -r XML
	do
		if	[[ "${XML:?}" =~ "<$tag>(.*)</$tag>" ]]
		then	print -- "${match[1]}"
		else	
			print # newline
			print -P -- "%F{red}error: tag %B<$tag>%b not found%f" >&2
		fi
	done
}

function process_serial serial
# Process serial number into the proper format required by the Apple support API
{
	local serial="${1:?}"

	case	"$serial"
	in
	(W*)	# S/Ns starting with W need to be resolved by their last three
		# characters
	    	serial="${serial:$#serial - 3:3}"
	;;
	(*)	serial="${serial:$#serial - 4:4}"
	;;
	esac

	print -- "$serial"
}

function main
# Read serial numbers from STDIN, spit out model names
{
	while	read -r SERIAL
	do
		: "$(process_serial "$SERIAL")"

		curl -sSL \
		     -w '\n' \
		     -X GET "${APPLE_SUPPORT_URL}${_}"

	done | get_xml_tag configCode
}

# Run main if not interactive
if	! [[ -o interactive ]] 
then	main
fi
